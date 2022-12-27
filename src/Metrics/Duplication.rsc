module Metrics::Duplication

import String;
import IO;
import lang::java::jdt::m3::Core;
import Prelude;
import Helpers::Helpers;
import Helpers::WhitespaceHelper;
import List;


list[str] duplicates;
str wholeProjectString;
//Duplicates is defined as a number, the duplicateLineCount

public int getNumberOfDuplicateLinesForEachClassInProject(loc project){
	duplicates = [""];
	int duplicateLines = 0;

	M3 model = createM3FromEclipseProject(project);
	wholeProjectString = removeLeadingSpacesForProjectLocation(project); //WS cleaned
 	for(decl <- model.declarations) {
		if(isClass(decl.name)) {
			int a = getNumberOfDuplicateLinesForLocation(decl.src, wholeProjectString);
			//println("Total amount of duplicate lines: <a> for <decl.src>"); 
			duplicateLines = a + duplicateLines;
		}	
	}
	
	//println("Total amount of duplicate lines for project: <duplicateLines>");
	return duplicateLines;
}

public int getNumberOfDuplicateLinesForLocation(loc currentClass, str wholeProjectString){
	
	int numberOfDuplicateLines = 0;
	
	//Lines to be evaluated if they have duplicates throughout the whole project
	list[str] fileLines = removeWhitespaceAndComments(currentClass); //WS cleaned
	
	while(size(fileLines) > 6){
		list[str] currentBlockOfStrings = take(6, fileLines);
		
		str linesOfCode = removeLeadingSpaces(currentBlockOfStrings); //WS cleaned double, but also concattenated
		
		if(linesOfCode notin duplicates){
		
		//check if string is in whole project
		list[int] occurencesInProject = findAll(wholeProjectString,linesOfCode);
		
		if(size(occurencesInProject) > 1){
			//Add to duplicates list
			duplicates = duplicates + [linesOfCode];

			int numberOfDuplicates = size(occurencesInProject) - 1;
			int currentNumberOfDuplicateLines =  numberOfDuplicates * 6;
			numberOfDuplicateLines = numberOfDuplicateLines + currentNumberOfDuplicateLines;
			}
		} 

		wholeProjectString = replaceAll(wholeProjectString,linesOfCode,"");
		fileLines = drop(6, fileLines);
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

