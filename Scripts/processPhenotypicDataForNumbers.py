#!/usr/bin/python3
# This script loads the phenotypic csv files from ABIDE I or ABIDE II and calculates
# number of autistics/controls, age range and number of individuals within each age-group, FIQ stats, Handedness, 
# names of medications & stimulants, number of subjects on medications and/or on stimulants

import sys, random, pandas, numpy as np
from pprint import pprint, pformat
from scipy import stats
#from dataFilterer import ageFIQMatcher
#TBD: find difference between ADOS_G_TOTAL and ADOS_2_TOTAL as phenotypic files in ABIDE I and ABIDEII differ in these respects.

print_rejection_message = 1; #set 0 to disable printing in analysable_data()

def ask_before_proceeding(reason):
    sys.stdout.write("Stopping. " + reason + ". Continue? [yes/no] ")
    yes = {'yes','y', 'ye', ''}
    no = {'no','n'}
    choice = input().lower()
    if choice in yes:
       return True
    elif choice in no:
       return False
    else:
       sys.stdout.write("Please respond with 'yes' or 'no'")
       return False

def rejection_message(sub_id, category):
    global print_rejection_message; 
    if print_rejection_message:
        print("Rejecting subject %d based on %s" %(sub_id, category))

def print_border(times): #number of times to print the border on same horizontal line
      border = "----------------------"
      if times <=0:
          return
      N = int(times)
      toprint = ""
      while(N > 0):
          N = N - 1
          toprint = toprint + border;
      print(toprint)

#contains all the conditions which can be discarding criteria for a row in phenotypic file
def analysable_data(abide_version, desired_eye_status, sub_id, row):
    if pandas.isna(row.EYE_STATUS_AT_SCAN) or int(row.EYE_STATUS_AT_SCAN) != desired_eye_status: #common for both ASD, control
        rejection_message(sub_id, 'EYE_STATUS_AT_SCAN')
        return False 
    if pandas.isna(row.FIQ) or row.FIQ == -9999:
        rejection_message(sub_id, 'FIQ')
        return False
    elif row.FIQ < 75:
        rejection_message(sub_id, 'FIQ below 75')
        return False

    if row.DX_GROUP != 1: #control data conditions
        if abide_version == 1:
            if (pandas.isna(row.HANDEDNESS_CATEGORY) or row.HANDEDNESS_CATEGORY != 'R') and (pandas.isna(row.HANDEDNESS_SCORES) or row.HANDEDNESS_SCORES <= 0):
                rejection_message(sub_id, 'handedness')
                return False
            if pandas.isna(row.FIQ) or row.FIQ == -9999:
                rejection_message(sub_id, 'FIQ')
                return False
        elif abide_version == 2:
            if (pandas.isna(row.HANDEDNESS_CATEGORY) or row.HANDEDNESS_CATEGORY != 1) and (pandas.isna(row.HANDEDNESS_SCORES) or row.HANDEDNESS_SCORES <= 0):
                rejection_message(sub_id, 'handedness')
                return False
            if pandas.isna(row.FIQ) or row.FIQ == -9999:
                rejection_message(sub_id, 'FIQ')
                return False
        else:
            print("Error. Abide version not known, got version:", abide_version)
            return False
        return True

    #ASD data checks
    if abide_version == 1:
        if (pandas.isna(row.HANDEDNESS_CATEGORY) or row.HANDEDNESS_CATEGORY != 'R') and (pandas.isna(row.HANDEDNESS_SCORES) or row.HANDEDNESS_SCORES <= 0):
            rejection_message(sub_id, 'handedness')
            return False   
        if (pandas.isna(row.ADOS_TOTAL) or row.ADOS_TOTAL == -10000) and (pandas.isna(row.ADOS_GOTHAM_TOTAL) or row.ADOS_GOTHAM_TOTAL == -9999):
            if (pandas.isna(row.ADOS_TOTAL) or row.ADOS_TOTAL == -10000): 
                rejection_message(sub_id, 'ADOS_TOTAL')
            if (pandas.isna(row.ADOS_GOTHAM_TOTAL) or row.ADOS_GOTHAM_TOTAL == -10000):
                rejection_message(sub_id, 'ADOS_GOTHAM_TOTAL')
            return False
        #if row.SEX != 1: #keeping male and female for now
        #    return False
        #if  pandas.isna(row.ADOS_RSRCH_RELIABLE) or not row.ADOS_RSRCH_RELIABLE:
        #    rejection_message(sub_id, 'ADOS_RSRCH_RELIABLE')  
        #    return False
    elif abide_version == 2:
       if (pandas.isna(row.HANDEDNESS_CATEGORY) or row.HANDEDNESS_CATEGORY != 1) and (pandas.isna(row.HANDEDNESS_SCORES) or row.HANDEDNESS_SCORES <= 0):
           rejection_message(sub_id, 'handedness')
           return False
       #if pandas.isna(row.ADOS_2_TOTAL) or row.ADOS_2_TOTAL == -9999: #it is ADOS_GOTHAM_TOTAL in ABIDE I.
       #    rejection_message(sub_id, 'ADOS_2_TOTAL')
       #    return False
       if pandas.isna(row.ADOS_G_TOTAL) or row.ADOS_G_TOTAL == -9999: #it is ADOS_TOTAL in ABIDE I.
           rejection_message(sub_id, 'ADOS_G_TOTAL')
           return False
       if pandas.isna(row.ADOS_RSRCH_RELIABLE) or not row.ADOS_RSRCH_RELIABLE:
           rejection_message(sub_id, 'ADOS_RSRCH_RELIABLE')
           return False
    else: #unknown abide version
        print("Error. Abide version not known, got version:", abide_version)
        return False
    return True

class subject_struct():
    def __init__(self):
        self.sub_ids = []; self.ages = []; self.fiqs = []; #subject id, age, FIQs
    def __repr__(self):
        return pformat(vars(self))

def print_medication_stats(abide_version, sub_ids, dataframe):
    if len(sub_ids) == 0:
        return
    #print(">>Medication Info<<")
    medications = []; subs_on_meds = []; #contains ids and medications
    subs_on_meds_and_stims = []; med_and_stims = []; #contains ids and medications of those on stimulants
    for sub_id in sub_ids:
        on_med = dataframe.CURRENT_MED_STATUS.loc[sub_id];
        off_stimulants = dataframe.OFF_STIMULANTS_AT_SCAN.loc[sub_id];
        if pandas.isna(on_med) or not on_med:
            continue
        meds = dataframe.CURRENT_MEDICATION_NAME.loc[sub_id].strip() if abide_version == 2 else dataframe.MEDICATION_NAME.loc[sub_id].strip()
        if pandas.isna(off_stimulants) or off_stimulants:
            subs_on_meds.append(sub_id);
            medications.append(meds);
            continue
        else:
            subs_on_meds_and_stims.append(sub_id)
            med_and_stims.append(meds)
    N = len(subs_on_meds)
    if N == 0:
        print("No subjects on medication.")
    else:
        print("%d subjects on medications:" % N, subs_on_meds)
        print("Medications:", medications)
    N = len(subs_on_meds_and_stims)
    if N == 0:
        print("No subjects on medication & stimulants.")
    else:
        print("%d subjects on medications+stimulants:" % N, subs_on_meds_and_stims)
        print("Medications+stimulants:", med_and_stims)

def print_stats(abide_version, group, gender, dataset, dataframe):
    print_border(1);
    print("Data for %s (%s)" %(group, gender));
    print_border(1);
    for age_group in ["children", "adolescents", "adults"]:
        sub_ids = dataset[group][gender][age_group].sub_ids
        ages = dataset[group][gender][age_group].ages
        fiqs = dataset[group][gender][age_group].fiqs
 
        print("|%s|" % (age_group))
        N = len(sub_ids)
        print("N = %d" % N)
        if N == 0:
            continue
        print("Subjects IDs - ", sub_ids)
        print("Age. Mean = %f, STD = %f, variance = %f, range=(%f, %f)"% (np.mean(ages), np.std(ages), np.var(ages), min(ages), max(ages)))
        print("FIQ. Mean = %f, STD = %f, variance = %f, range=(%f, %f)"% (np.mean(fiqs), np.std(fiqs), np.var(fiqs), min(fiqs), max(fiqs)))
        print_medication_stats(abide_version, sub_ids, dataframe)

#two lists. The lists are made of tuples of the form (subjectID, age, fiq) of corresponding subjects.
#returns [t_age,p_age,t_fiq,p_fiq]; [-1000,-1000,-1000,-1000] if invalid. 
def get_print_ASD_TD_stats(sample_asd, sample_control, printMessage=True):
    if len(sample_asd) and len(sample_control):
        sample_asd_age = [val[1] for val in sample_asd]
        sample_asd_fiq = [val[2] for val in sample_asd]
        sample_control_age = [val[1] for val in sample_control]
        sample_control_fiq = [val[2] for val in sample_control]
        t_age,p_age=stats.ttest_ind(sample_asd_age,sample_control_age)
        t_fiq,p_fiq=stats.ttest_ind(sample_asd_fiq,sample_control_fiq)
 
        if printMessage:
            print('asd(N=%d). mean(age) = %f±%f,mean(fiq) = %f±%f ' %(len(sample_asd_age), np.mean(sample_asd_age), np.std(sample_asd_age),np.mean(sample_asd_fiq), np.std(sample_asd_fiq)))
            print('control(N=%d). mean(age) = %f±%f,mean(fiq) = %f±%f' %(len(sample_control_age), np.mean(sample_control_age), np.std(sample_control_age),np.mean(sample_control_fiq), np.std(sample_control_fiq)))
            print('t_age=%f,p_age=%f, asd_range(age)=(%f,%f), cntr_range(age)=(%f,%f)'%(t_age,p_age, min(sample_asd_age), max(sample_asd_age), min(sample_control_age), max(sample_control_age)))
            print('t_fiq=%f,p_fiq=%f, asd_range(fiq)=(%f,%f), cntr_range(fiq)=(%f,%f)'%(t_fiq,p_fiq, min(sample_asd_fiq), max(sample_asd_fiq), min(sample_control_fiq), max(sample_control_fiq)))
        return [t_age,p_age,t_fiq, p_fiq]
    else:
        if printMessage:
            print('No data found')
        return [-1000,-1000,-1000,-1000]

def ageFIQMatcher(asd_data, control_data, ITER_CNT=10**5):
    global ProceedByDefault
    N_asd = len(asd_data)
    N_control = len(control_data)
    minLen = min(N_asd, N_control)
    message = 'Got %d asd, %d control' %(N_asd, N_control)
    if not ProceedByDefault:
        proceed = ask_before_proceeding(message)
        if not proceed:
            return [],[]
    else:
        print(message)
    
    #ITER_CNT = 10**5 
    [MIN_t_fiq, MIN_t_age, MAX_p_age, MAX_p_fiq] = [10**4,10**4,0,0]
    desired_asd_sample = []; desired_control_sample = [];
    for n_asd in range(minLen, min(10,minLen)-1, -1):
        min_num = max(min(10,minLen), n_asd-3); max_num = min(N_control,n_asd+3);
        print('will go from %d to %d in this run' %(min_num, max_num))
        if n_asd < 2 or max_num < 2:
            print('not enough subjects. Will skip.')
            continue
        for n_control in range(min_num, max_num+1):
            print('\nRunning sim for n_asd = %d, n_control = %d'% (n_asd, n_control))
            cnt = ITER_CNT
            sample_asd = []; sample_control = [];
            [t_age,p_age,t_fiq,p_fiq] = [0,0,0,0] #defining them to be accessible later
            [max_p_age, max_p_fiq] = [0,0]
            curr_asd_sample = []; curr_control_sample = [];
            [min_t_age,min_t_fiq] = [10**4,10**4];
            matched = set()
            while cnt > 0:
                matched.clear()
                cnt = cnt - 1
                sample_asd = random.sample(asd_data, n_asd)
                sample_control = random.sample(control_data, n_control)
                if not len(sample_asd) or not len(sample_control):
                    continue
                sample_asd_fiq = [val[2] for val in sample_asd]
                sample_control_fiq = [val[2] for val in sample_control]
                [t_age,p_age,t_fiq,p_fiq] = get_print_ASD_TD_stats(sample_asd, sample_control, False)
                if abs(t_age) > 0.6:
                    continue
                elif (abs(t_age) <= 0.6):
                    if min_t_fiq > abs(t_fiq) and max_p_fiq <= p_fiq:
                        min_t_fiq = abs(t_fiq)
                        max_p_fiq = p_fiq
                        curr_asd_sample = sample_asd
                        curr_control_sample = sample_control
 
            if MIN_t_fiq > min_t_fiq and MAX_p_fiq <= p_fiq:
                MIN_t_fiq = min_t_fiq
                MAX_p_fiq = p_fiq
                desired_asd_sample = curr_asd_sample
                desired_control_sample = curr_control_sample 

            #print stats for the run
            t_val = get_print_ASD_TD_stats(curr_asd_sample, curr_control_sample)[0];
            print("ASD subjectid,age,fiq - ", curr_asd_sample)
            print("Control subjectid,age,fiq - ", curr_control_sample)
            if t_val != -1000 and not ProceedByDefault:
                proceed = ask_before_proceeding('Please refer to current run data above.')
                if not proceed:
                    break
  
    print('\ndesired sample from last run')
    get_print_ASD_TD_stats(desired_asd_sample, desired_control_sample);  
    
    return desired_asd_sample, desired_control_sample

def find_age_matched_subjects(dataset):
    global ProceedByDefault
    #global desiredFIQMean, desiredFIQstd
    sub_id_set = set(); #set for already considered sub_ids
    for gender in ['male', 'female']:
        print_border(2);
        print("Age-matched ASD/control subjects for %s subjects" %(gender))
        print_border(2);
        #for age_group in ["children", "adolescents", "adults"]:
        for age_group in ["children"]:
        #for age_group in ["adults"]:
            sub_id_set.clear() #clear the set for each iteration
            print("|%s|"% age_group)
            asd_ids = dataset["asd"][gender][age_group].sub_ids;
            asd_ages = dataset["asd"][gender][age_group].ages;
            asd_fiqs = dataset["asd"][gender][age_group].fiqs;
            asd_id_age_fiq = list(zip(asd_ids, asd_ages, asd_fiqs))
            #asd_id_age_fiq = sorted(list(zip(asd_ids, asd_ages, asd_fiqs)), key=lambda x:x[1]) #merge lists together & sort them based on age
            
            control_ids = dataset["control"][gender][age_group].sub_ids;
            control_ages = dataset["control"][gender][age_group].ages;
            control_fiqs = dataset["control"][gender][age_group].fiqs;  
            control_id_age_fiq = list(zip(control_ids, control_ages, control_fiqs))
            #control_id_age_fiq = sorted(list(zip(control_ids, control_ages, control_fiqs)), key=lambda x:x[1])#merge lists together & sort them based on age
            matched_asd_subs, matched_control_subs = ageFIQMatcher(asd_id_age_fiq, control_id_age_fiq,10**5)
            print("ASD subjectid,age,fiq - ", matched_asd_subs)
            print("Control subjectid,age,fiq - ", matched_control_subs, '\n')
            
#age_match_threshold = 0.4; #threshold for matching age. ABIDE just mentions that age is in years. Assuming multiplying by 365.25 days gives the age in days.
#desiredFIQMean = 100; desiredFIQstd = 15; 
#fiq_match_threshold = 0.05 * 100;
eye_status_at_scan = 1; #1 for open, 2 for closed. This will also be used to filter relevant data.
abide_version = 1; # 1 for ABIDE I. 2 for ABIDE II. Necessary because the column names/defs differ.
ProceedByDefault = 1; #for proceeding where prompts are present

filepath = "../Data Pool/Selected Data/ABIDE I/phenotypic_USM.csv";  
#filepath = "../Data Pool/Selected Data/ABIDE I/phenotypic_UniMichigan_Sample1.csv";  
#filepath = "../Data Pool/Selected Data/ABIDE I/phenotypic_UniMichigan_Sample2.csv";  
#filepath = "../Data Pool/Selected Data/ABIDE I/NYU Langone/phenotypic_NYU.csv";
#filepath = "../Data Pool/Selected Data/ABIDE I/phenotypic_OLIN.csv";
#filepath = "../Data Pool/Selected Data/ABIDE I/phenotypic_LEUVEN_1.csv"; #ADOS TOTAL or GOTHAM not available
#filepath = "../Data Pool/Selected Data/ABIDE I/phenotypic_KKI.csv";
#filepath = "../Data Pool/Selected Data/ABIDE I/phenotypic_PITT.csv";
#filepath = "../Data Pool/Selected Data/ABIDE II/ABIDEII-NYU_1.csv";
#filepath = "../Data Pool/Selected Data/ABIDE II/ABIDEII-TCD_1.csv";
#filepath = "../Data Pool/Selected Data/ABIDE II/ABIDEII-USM_1.csv";  
#filepath = "../Data Pool/Selected Data/ABIDE II/ABIDEII-ETH_1.csv";
#filepath = "../Data Pool/Selected Data/ABIDE II/ABIDEII-ONRC_2.csv";

df = pandas.read_csv(filepath, index_col='SUB_ID'); #load the dataframe with index as 'SUB_ID'
df.columns = df.columns.str.strip() #column names have whitespaces in ABIDE II, causing problems while referencing cells in panda dataframe
dataset = {
        "asd":{
            "male": {"children": subject_struct(), "adolescents": subject_struct(), "adults": subject_struct()},
            "female":{"children": subject_struct(), "adolescents": subject_struct(), "adults": subject_struct()},
            },
        "control":{
            "male": {"children": subject_struct(), "adolescents": subject_struct(), "adults": subject_struct()},
            "female":{"children": subject_struct(), "adolescents": subject_struct(), "adults": subject_struct()},
            },
        };
print("ABIDE version: %d. Eye status: %d. Reference phenotype file - %s" %(abide_version, eye_status_at_scan, filepath))
for subid, row in df.iterrows():
    if not analysable_data(abide_version, eye_status_at_scan, subid, row):
        continue
    group = 'asd' if row.DX_GROUP == 1 else 'control';
    gender = 'male' if row.SEX == 1 else 'female';
    age_group = 'children' if row.AGE_AT_SCAN <= 12 else ('adolescents' if row.AGE_AT_SCAN <= 17.9 else 'adults');
    dataset[group][gender][age_group].sub_ids.append(subid);
    dataset[group][gender][age_group].ages.append(row.AGE_AT_SCAN);
    dataset[group][gender][age_group].fiqs.append(row.FIQ);
#pprint(dataset)

#for group in ['asd', 'control']:
#    for gender in ['male', 'female']:
#        print_stats(abide_version, group, gender, dataset, df)
# code for age-matching within a group
find_age_matched_subjects(dataset)
#asd_male_adults = {'ages': dataset['asd']['male']['adults'].ages, 'fiqs': dataset['asd']['male']['adults'].fiqs }; 
#control_male_adults = {'ages': dataset['control']['male']['adults'].ages, 'fiqs': dataset['control']['male']['adults'].fiqs }; 

