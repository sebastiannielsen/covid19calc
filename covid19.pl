#!/usr/bin/perl

use CGI ':standard';

# OR ratios for blood types A, B, AB and 0, for the 2 Wuhan hospitals combined
# SOURCE: https://www.medrxiv.org/content/10.1101/2020.03.11.20031096v2.full.pdf
# ----------------------------------------
# A = 1.286 B = 1.069 AB = 1.138 0 = 0.678
#Normalized using a reduction rate of 1.000 / 1.286 = 0.7776049766718507
#Normalized values:
# A = 1.000 B = 0.831 AB = 0.885 0 = 0.527

# Reason for normalization: So we get a value between 0 and 1, where 0 means no risk of COVID19 infection at all, and 1 means basically guranteed to catch COVID19.

@bloodtypes = (1.000, 0.831, 0.885, 0.527);
@bloodnames = ('A','B','AB','0');
# Age distribution of COVID19 infections in sweden, as of 2020-04-14 from Swedish Citizen Health Authority

# 0-9 = 63
# 10-19 = 162
# 20-29 = 802
# 30-39 = 1025
# 40-49 = 1400
# 50-59 = 1900
# 60-69 = 1529
# 70-79 = 1541
# 80-89 = 1672
# 90+ = 848

# Normalized using a percentage value derived from the maximum of 1900:

# 0-9 = 0.033
# 10-19 = 0.085
# 20-29 = 0.422
# 30-39 = 0.539
# 40-49 = 0.737
# 50-59 = 1.000
# 60-69 = 0.804
# 70-79 = 0.811
# 80-89 = 0.880
# 90+ = 0.466

@agegroups = (0.033, 0.085, 0.422, 0.539, 0.737, 1.000, 0.804, 0.811. 0.880, 0.466);
@agenames = ('0 - 9', '10 - 19', '20 - 29', '30 - 39', '40 - 49', '50 - 59', '60 - 69', '70 - 79', '80 - 89', '90+');

# Gender distribution, as of 2020-04-14 from Swedish Citizen Health Authority:
# Male: 5350 (0.956 value against the females)
# Felmale: 5596

@gender = (0.956, 1.000);
@gendernames = ('Man / Male', 'Kvinna / Female');

$bt = param('bt');
$ag = param('ag');
$g = param('g');
$s = param('s');

$bt =~ s/[^0123]*//sgi;
$ag =~ s/[^0123456789]*//sgi;
$g =~ s/[^01]*//sgi;
$bt = substr($bt,0,1);
$ag = substr($ag,0,1);
$g = substr($g,0,1);

print "Content-Type: text/html\n\n<html><head><title>COVID-19 Infection Risk Calculator</title></head><body>";
print "<h1>COVID-19 Infektionsriskkalkylator / Infection Risk Calculator</h1>";

if ($s eq "1") {

print "<font size='6'>";
print "Dina data / Your details:<br><br>";
print "Blodgrupp / Blood Group: ".$bloodnames[$bt]."<br>";
print "&Aringldersgrupp / Age Group: ".$agenames[$ag]."<br>";
print "K&ouml;n / Gender: ".$gendernames[$g]."<br>";
print "<br><br>";

$infectionrisk = 1000;
$infectionrisk = $infectionrisk * $bloodtypes[$bt];
$infectionrisk = $infectionrisk * $agegroups[$ag];
$infectionrisk = $infectionrisk * $gender[$g];

$infectionrisk = int($infectionrisk);
$infectionrisk = $infectionrisk / 10;

print "Din COVID-19 Infektionsrisk / Your COVID-19 Infection Risk: ".$infectionrisk." %";
print "</font>";
}
else
{

print "<form method='POST'><font size='5'>";
print "Blodgrupp / Blood Group: <select name='bt'><option value='0' selected>A</option><option value='1'>B</option><option value='2'>AB</option><option value='3'>0</option></select><br><br>";
print "&Aring;ldersgrupp / Age Group: ";
print "<select name='ag'>";
print "<option value='0' selected>0 - 9</option>";
print "<option value='1'>10 - 19</option>";
print "<option value='2'>20 - 29</option>";
print "<option value='3'>30 - 39</option>";
print "<option value='4'>40 - 49</option>";
print "<option value='5'>50 - 59</option>";
print "<option value='6'>60 - 69</option>";
print "<option value='7'>70 - 79</option>";
print "<option value='8'>80 - 89</option>";
print "<option value='9'>90+</option>";
print "</select><br><br>";
print "K&ouml;n / Gender:<br>";
print "<input type='radio' name='g' value='0' checked> Man / Male<br>";
print "<input type='radio' name='g' value='1'> Kvinna / Female<br>";
print "<input type='hidden' name='s' value='1'>";
print "<br><br><input type='submit'></fotm>";

}
print "<br><br>Source code: <a href='https://github.com/sebastiannielsen/covid19calc/'>https://github.com/sebastiannielsen/covid19calc/</a>";
print "</body></html>";
