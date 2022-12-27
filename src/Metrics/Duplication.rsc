module Metrics::Duplication

import String;
import IO;
import lang::java::jdt::m3::Core;
import Prelude;
import Helpers::Helpers;


list[str] duplicates;

//Duplicates is defined as a number, the duplicateLineCount

public int getNumberOfDuplicateLinesForEachClassInProject(loc project){
	duplicates = [""];
	int duplicateLines = 0;

	M3 model = createM3FromEclipseProject(project);
 	for(decl <- model.declarations) {
		if(isClass(decl.name)) {
			int a = getNumberOfDuplicateLinesForLocation(decl.src, project);
			//println("Total amount of duplicate lines: <a> for <decl.src>"); 
			duplicateLines = a + duplicateLines;
		}	
	}
	
	//println("Total amount of duplicate lines for project: <duplicateLines>");
	return duplicateLines;
}

public int getNumberOfDuplicateLinesForLocation(loc currentClass, loc project){
	int numberOfDuplicateLines = 0;
	
	//Lines to be evaluated if they have duplicates throughout the whole project
	list[str] fileLines = readFileLines(currentClass);
	str wholeProjectString = removeLeadingSpacesForProjectLocation(project);
	
	while(size(fileLines) > 6){
		list[str] currentBlockOfStrings = take(6, fileLines);
		
		str linesOfCode = removeLeadingSpaces(currentBlockOfStrings);
		
		if(linesOfCode notin duplicates){
		
		//check if string is in whole project
		list[int] occurencesInProject = findAll(wholeProjectString,linesOfCode);
		
		if(size(occurencesInProject) > 1){
			//Add to duplicates list
			duplicates += [linesOfCode];
			
			int numberOfDuplicates = size(occurencesInProject) - 1;
			numberOfDuplicateLines = numberOfDuplicateLines + numberOfDuplicates * 6;
		//	println("linesOfCode block was found <size(occurencesInProject)> times");
			}
		}
		//If this line isn't commented, we make all possible amount of blocks of 6, reaching a number much larger than our total amount of lines
		fileLines = drop(1, fileLines);
		//fileLines = drop(6, fileLines);
	}
	
	return numberOfDuplicateLines;
}

//As Defined in the article
public str getDuplicationRank(int duplicationPercentage){
	if (duplicationPercentage<=3){
		return "++";
	} else if(duplicationPercentage<=5){
		return "+";
	} else if (duplicationPercentage<=10){
		return "O";
	} else if (duplicationPercentage<=20){
		return "-";
	}
	return "--";
}

