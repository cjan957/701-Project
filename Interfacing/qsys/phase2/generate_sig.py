

values = ["00","00", "FF" , "00", "00", "00" , "FF", "FF", "00", "00", "00", "00", "FF", "00", "00","00","00","FF", "00", "00", "FF","FF","FF","FF","FF"];

temp_array = "";

time_s = 4;

for index in range (0 , len(values)):
	temp_array += "x" + '"' + values[index] + '"' + ' after ' + str(time_s) + ' ns';
	time_s += 4;
	
	if (index == len(values) - 1) :
		temp_array += ";";
	else:
		temp_array += ",\n";


	
text_file = open("TEST.txt", "w");
text_file.write(temp_array);
text_file.close();