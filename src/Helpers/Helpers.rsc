module Helpers::Helpers


import util::Resources;
import IO;
import List;
import Map;
import Set;
import analysis::graphs::Graph;
import lang::java::m3::AST;
import String;
import Helpers::WhitespaceHelper;


public set[loc] javaBestanden(loc project) {
   Resource r = getProject(project);
   return { a | /file(a) <- r, a.extension == "java" };
}



//removeLeadingSpaces
public str removeLeadingSpaces(list[str] linesOfCode){
	str resultString = "";
	list[str] cleanedUpLines = removeWhitespaceAndCommentsForListOfString(linesOfCode);
	while(size(cleanedUpLines) > 0){
		resultString = resultString + trim(cleanedUpLines[0]);
		cleanedUpLines = drop(1, cleanedUpLines);
	}
	//removes the leading spaces and also concats newLine into the same line with newline character
	return resultString;
}

//removeLeadingSpaces and Comments
public str removeLeadingSpacesForProjectLocation(loc project){

    set[loc] bestanden = javaBestanden(project);
	str resultString = "";

	
	for(loc l <- bestanden){
	 list[str] fileLines = removeWhitespaceAndComments(l);
	 resultString = resultString + removeLeadingSpaces(fileLines);
    }
    
    
	
	//removes the leading spaces and also concats newLine into the same line with newline character
	return resultString;
}

public real weighted_average(list[real] values, list[real] weights)
{
  real sum = 0.0;
  real weight_sum = 0.0;
  int i = 0;
  while (i<size(values)){
  	sum += values[i] * weights[i];
    weight_sum += weights[i];
    i=i+1;
  }

  return sum / weight_sum;
}


public void testWeighted_Average(){
	list[real] values = [100.0, 90.0, 80.0, 70.0, 60.0];
	list[real] weights = [0.2, 0.1, 0.1, 0.3, 0.3];
	
	real avg = weighted_average(values, weights);
	println(avg); //Should be: 76.0
}

public int getIntScore(str score){
	if (score == "--")
		return 1;
	else if (score =="-")
		return 2;
	else if (score =="O")
		return 3;
	else if (score =="+")
		return 4;
	else
		return 5;
}


