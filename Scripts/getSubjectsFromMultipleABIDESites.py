#this script takes multiple lists (of tuples - subjectID, age,fiq) and calculates statistics.
#from matplotlib import pyplot as plt
#plt.rcParams["figure.figsize"] = [10, 6];
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt

#plots quantity where label becomes xlabel
def binPlotter(data, diaggroup, agegroup, label):
    fig = plt.figure()
    plt.hist(data)
    fig.suptitle('%s %s' %(diaggroup, agegroup), fontsize=18)
    plt.xlabel(label, fontsize=15)
    plt.ylabel('count', fontsize=15)
    fig.savefig('%s_%s_%s.jpg' %(diaggroup, agegroup, label))

age_group = ["children", "adolescents", "adults"];
diagnostic_group = ["asd", "td"];
abide_sites = ["uni_michSamp1", "uni_michSamp2", "eth_zurich1_abide2", "nyu_abide1", "usm_abide1"];

abideSitesConsidered = {
        "children": ["uni_michSamp1", "nyu_abide1"],
        "adolescents": ["uni_michSamp1","uni_michSamp2", "nyu_abide1"],
        "adults": ["eth_zurich1_abide2", "nyu_abide1", "usm_abide1"]
        };
## next three lines for code initialisation. comment out when not required.
#for age in age_group:
#    print('abideSiteData[\"%s\"] = {};'% (age));
#    for site in abide_sites:
#        print('abideSiteData[\"%s\"][\"%s\"] = {};'% (age, site))

#initialise the dict
abideSiteData = {};
abideSiteData["children"] = {};
abideSiteData["children"]["uni_michSamp1"] = {};
abideSiteData["children"]["uni_michSamp2"] = {};
abideSiteData["children"]["eth_zurich1_abide2"] = {};
abideSiteData["children"]["nyu_abide1"] = {};
abideSiteData["children"]["usm_abide1"] = {};
abideSiteData["adolescents"] = {};
abideSiteData["adolescents"]["uni_michSamp1"] = {};
abideSiteData["adolescents"]["uni_michSamp2"] = {};
abideSiteData["adolescents"]["eth_zurich1_abide2"] = {};
abideSiteData["adolescents"]["nyu_abide1"] = {};
abideSiteData["adolescents"]["usm_abide1"] = {};
abideSiteData["adults"] = {};
abideSiteData["adults"]["uni_michSamp1"] = {};
abideSiteData["adults"]["uni_michSamp2"] = {};
abideSiteData["adults"]["eth_zurich1_abide2"] = {};
abideSiteData["adults"]["nyu_abide1"] = {};
abideSiteData["adults"]["usm_abide1"] = {};

#fill asd children's data.
abideSiteData["children"]["uni_michSamp1"]["asd"] = [(50286, 11.2, 130.5), (50288, 11.1, 105.0), (50312, 11.2, 91.0), (50295, 11.5, 135.0), (50317, 9.8, 115.0), (50303, 11.6, 84.0), (50306, 8.5, 76.0), (50283, 11.2, 97.5), (50310, 9.7, 78.5), (50281, 10.7, 132.0), (50316, 11.8, 109.0), (50305, 10.9, 85.0)];
abideSiteData["children"]["nyu_abide1"]["asd"] = [(50980, 8.52, 136), (51007, 11.92, 108), (50991, 10.9, 100), (51014, 11.005, 106), (50977, 7.13, 142), (50965, 9.25, 132), (50979, 9.37, 114), (50978, 9.58, 142), (51035, 10.27, 100), (51034, 10.65, 109), (51003, 8.51, 120), (50968, 9.95, 108), (50970, 8.9, 99), (50975, 10.96, 100), (50983, 10.48, 117), (50982, 9.46, 119), (51006, 11.11, 103)];
#fill td children's data.
abideSiteData["children"]["uni_michSamp1"]["td"] = [(50358, 9.8, 99.5), (50355, 10.9, 127.5), (50372, 10.2, 107.5), (50377, 11.5, 113.5), (50332, 10.4, 103.5), (50359, 10.4, 85.0), (50364, 10.8, 97.0), (50337, 11.8, 112.0), (50334, 11.0, 108.0), (50376, 9.2, 98.5), (50333, 10.2, 100.5)];
abideSiteData["children"]["nyu_abide1"]["td"] = [(51084, 9.23, 118), (51121, 10.74, 113), (51086, 10.46, 119), (51087, 10.52, 111), (51120, 10.19, 115), (51082, 8.88, 119), (51090, 11.03, 107), (51069, 8.15, 118), (51089, 10.76, 138), (51093, 11.69, 116), (51085, 9.81, 101), (51091, 11.32, 142), (51081, 8.82, 98), (51083, 8.93, 100), (51080, 8.01, 110)];

#fill adolescent's data.
abideSiteData["adolescents"]["uni_michSamp1"]["asd"] = [(50298, 12.8, 101.0), (50274, 14.2, 111.5), (50273, 16.8, 112.5), (50272, 14.2, 98.5), (50297, 15.9, 125.5), (50323, 14.2, 125.0), (50314, 16.1, 126.0), (50290, 14.0, 108.5), (50296, 15.1, 89.0), (50315, 13.4, 118.5), (50324, 13.8, 124.5), (50291, 13.9, 96.0)];
abideSiteData["adolescents"]["uni_michSamp1"]["td"] = [(50370, 12.8, 93.5), (50371, 12.2, 97.5), (50342, 12.6, 103.5), (50328, 17.4, 91.5), (50360, 13.9, 113.5), (50351, 16.8, 116.0), (50350, 12.4, 109.5), (50347, 15.6, 122.0), (50381, 16.5, 114.5), (50330, 16.1, 120.0)];
abideSiteData["adolescents"]["uni_michSamp2"]["asd"] = [(50404, 15.8, 129.5), (50405, 16.6, 94.0), (50410, 16.1, 110.5), (50408, 14.8, 118.5), (50402, 13.1, 121.0), (50403, 12.8, 120.5), (50412, 13.2, 133.5), (50406, 15.2, 90.5)];
abideSiteData["adolescents"]["uni_michSamp2"]["td"] = [(50416, 14.8, 108.5), (50383, 14.4, 116.0), (50418, 14.9, 112.0), (50423, 14.1, 111.5), (50422, 14.8, 114.5), (50426, 13.6, 113.0), (50421, 15.4, 116.0), (50419, 15.8, 111.0)];
abideSiteData["adolescents"]["nyu_abide1"]["asd"] = [(50976, 14.65, 127), (50964, 12.75, 106), (50998, 13.04, 91), (50984, 13.2, 98), (50994, 15.66, 102), (50985, 13.09, 90), (50995, 16.74, 109), (50972, 13.95, 100), (50990, 13.71, 131), (50973, 17.88, 112)];
abideSiteData["adolescents"]["nyu_abide1"]["td"] = [(51104, 15.27, 104), (51096, 13.18, 101), (51108, 15.71, 108), (51127, 16.55, 91), (51101, 14.425, 104), (51107, 15.53, 107), (51109, 16.13, 109), (51095, 12.23, 123), (51125, 14.79, 112), (51094, 12.1, 107)];

#fill adult's data.
abideSiteData["adults"]["eth_zurich1_abide2"]["asd"] = [(29068, 18.5, 95), (29065, 18.91666667, 106), (29060, 20.16666667, 104), (29058, 22.08333333, 123), (29067, 21.0, 123), (29070, 22.5, 82), (29057, 27.25, 112), (29059, 24.58333333, 118), (29066, 19.66666667, 115), (29062, 20.16666667, 111)];
abideSiteData["adults"]["eth_zurich1_abide2"]["td"] = [(29082, 22.25, 121), (29094, 19.25, 109), (29071, 18.0, 116), (29081, 19.58333333, 124), (29091, 26.41666667, 100), (29093, 20.16666667, 126), (29075, 21.66666667, 119), (29079, 22.66666667, 113), (29092, 27.41666667, 101), (29078, 23.91666667, 118)];
abideSiteData["adults"]["nyu_abide1"]["asd"] = [(51024, 39.1, 98), (51028, 29.18, 80), (51015, 29.98, 105), (51016, 22.99, 134), (51021, 23.66, 112), (51018, 20.25, 116), (51017, 22.04, 137), (51029, 26.516, 107), (51025, 19.64, 94), (51023, 20.62, 115)];
abideSiteData["adults"]["nyu_abide1"]["td"] = [(51146, 20.02, 106), (51148, 20.3, 107), (51155, 30.78, 104), (51153, 26.17, 114), (51113, 22.38, 109), (51149, 20.56, 113), (51119, 30.724, 123), (51154, 30.08, 104), (51117, 28.203000000000003, 103), (51116, 25.34, 115)];
abideSiteData["adults"]["usm_abide1"]["asd"] = [(50498, 21.1307, 99), (50480, 29.0897, 127), (50482, 27.4114, 94), (50531, 28.0903, 112), (50477, 20.1807, 92), (50514, 21.4018, 109), (50496, 24.3231, 129), (50483, 21.4346, 96), (50478, 20.178, 91), (50491, 26.9487, 125), (50499, 25.4346, 113), (50485, 23.5948, 132), (50475, 21.6482, 117), (50507, 28.1095, 97)];
abideSiteData["adults"]["usm_abide1"]["td"] = [(50455, 31.2827, 112), (50440, 23.948, 98), (50462, 24.6543, 120), (50450, 21.0979, 95), (50452, 29.9685, 112), (50469, 28.5613, 134), (50445, 18.1383, 128), (50434, 18.2615, 93), (50472, 22.1081, 104), (50467, 19.7591, 89), (50441, 27.5975, 123), (50473, 22.4367, 106)];

#tuple of (site, subid, age, fiq)
collatedData = {"asd": {"children":[], "adolescents":[], "adults":[]},
        "td":{"children":[], "adolescents":[], "adults":[]} };

for group in diagnostic_group:
    for age in age_group:
        for site in abideSitesConsidered[age]:
            subjData = abideSiteData[age][site][group];
            for subj in subjData:
                tpl = (site, subj[0], subj[1], subj[2]);
                collatedData[group][age].append(tpl);

for group in diagnostic_group:
    for age in age_group:
        ages = [x[2] for x in collatedData[group][age]];
        fiqs = [x[3] for x in collatedData[group][age]];
        min_age = min(ages); max_age = max(ages);
        min_fiq = min(fiqs); max_fiq = max(fiqs);
        #binPlotter(ages, group, age, 'age');
        print('%s %s. N = %d, range(age) = (%f,%f), mean(age) = %f±%f, range(fiq) = (%f,%f), mean(fiq) = %f±%f' %(group, age, len(fiqs), min_age, max_age, np.mean(ages), np.std(ages), min_fiq, max_fiq, np.mean(fiqs), np.std(fiqs)));


