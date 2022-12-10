module Helpers::Helpers


import util::Resources;
import IO;
import List;
import Map;
import Set;
import analysis::graphs::Graph;
import lang::java::m3::AST;
import String;


public set[loc] javaBestanden(loc project) {
   Resource r = getProject(project);
   return { a | /file(a) <- r, a.extension == "java" };
}



//removeLeadingSpaces
public str removeLeadingSpaces(list[str] linesOfCode){
	str resultString = "";
	
	while(size(linesOfCode) > 0){
		resultString = resultString + trim(linesOfCode[0]);
		linesOfCode = drop(1, linesOfCode);
	}
	//removes the leading spaces and also concats newLine into the same line with newline character
	return resultString;
}

//removeLeadingSpaces
public str removeLeadingSpacesForProjectLocation(loc project){

    set[loc] bestanden = javaBestanden(project);
	str resultString = "";

	
	for(loc l <- bestanden){
	 list[str] fileLines = readFileLines(l);
	 resultString = resultString + removeLeadingSpaces(fileLines);
    }
    
    
	
	//removes the leading spaces and also concats newLine into the same line with newline character
	return resultString;
}



public int Metric_Volume_LOC() {
   loc project = |project://smallsql/|;
   set[loc] bestanden = javaBestanden(project);
   
	int totaalAantalRegels = 0;
	
    for(loc l <- bestanden){
        //Unit in this case corresponds to a file
    	totaalAantalRegels = totaalAantalRegels + GetUnitSize(l);
    }

	return totaalAantalRegels;
}

