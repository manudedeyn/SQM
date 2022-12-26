module Metrics::Maintainability
import IO;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import Prelude;
import Helpers::Helpers;
import Helpers::WhitespaceHelper;
import util::Math;

/*
	Returns the amount of methods in the project
*/
public int numberOfMethods(loc project){ 		
	 int counter = 0;
	 M3 model = createM3FromEclipseProject(project);
	 	for(decl <- model.declarations) {
			if(isMethod(decl.name)) {	
				ast = createAstFromFile(toLocation(decl.src.uri), false);
			
				visit(ast) {
					case m:\method(_,_,_,_,imp): {
						if(m.src == decl.src) { 
							counter = counter+1;					
						}
					}
					case c:\constructor(_,_,_,imp): {
						counter = counter+1;	
					}
		 		}					
			}	
	 	} 	
  
   return counter; 
}

/*
This function returns a ratio. It is the ratio between unit test and total amount of methods.
Example usage: getRatioUnitTestsAndMethods(|project://smallsql/|);
*/
real ratioUnitTestsAndMethods = 0.0;
public real getRatioUnitTestsAndMethods(loc project) {
	set[loc] bestanden = javaBestanden(project);
   	int numberMethods = numberOfMethods(project);
 	int totaalAantalRegels = 0;
	
	int counter = 0;
    for(loc l <- bestanden){
    	list[str] allFileLines = readFileLines(l);
		for(line <- allFileLines){
			if (contains(line, "@Test")){
				counter = counter+1;
			}
	    }
	 }

	//In case there are no tests or if testing is done in a different way (not @Test).
	if (counter == 0){
		ratioUnitTestsAndMethods = -1.0;
		return ratioUnitTestsAndMethods;
	}
	
	ratioUnitTestsAndMethods = toReal(counter)/toReal(numberMethods);
	return ratioUnitTestsAndMethods;
}



/*
	Analysability: "How difficult/easy is it to diagnose deficiencies"
	To measure analysability, the activity recording measure is suggested (is numberDataItemsWithLoggingImplemented/numberDataItemsWhichRequireLogging)
	For analysability: volume, duplication, unitsize, unit testing are considered
*/
public str getAnalysabilityScore(str volume, str duplication, str unitSize, str testability){
	return calculateAverageScore([volume,duplication,unitSize,testability]);
}

int getNumberRepresentationOfScore(str score){
	if (score == "--"){
		return 1;
	}else if (score == "-"){
		return 2;
	}
	else if (score == "+"){
		return 4;
	}else if (score == "++"){
		return 5;
	}
	
	return 3; //Neutral
}

//Rounded to floor
str getStringRepresentationOfScore(real score){
	str ret = "O";
	if (score < 2){
		ret = "--";
	}else if (score < 3){
		ret = "-";
	}else if (score < 4){
		ret = "O";
	}
	else if (score < 5){
		ret = "+";
	}else{
		ret = "++";
	}
	return ret;
}

//Example: calculateAverageScore(["--","--","++"]) will output: "-"
str calculateAverageScore(list[str] scores){
	int totalScore = 0;
	for (score <- scores){
		totalScore = totalScore + getNumberRepresentationOfScore(score);
	}
	real avgScore = toReal(totalScore)/size(scores);
	return getStringRepresentationOfScore(avgScore);
}


/*
	For changability complexity and duplication are considered
	Both are weighted equally.
*/
public str getChangabilityScore(str complexityScore, str duplicationScore){
	return calculateAverageScore([complexityScore,duplicationScore]);
}

/*
	They recommended the unit size, complexity/unit and unit testing.
	We removed unit size out of this which was recommended by the article.
	For testability: complexityScore and unit testing are considered
*/
public str getTestabilityScore(loc project, str complexityScore){
	if (ratioUnitTestsAndMethods == 0.0){
		getRatioUnitTestsAndMethods(project);
	}
	
	if (ratioUnitTestsAndMethods > 0.25){
		//In this case we think it has excellent test Coverage
		return "++";
	}else if (ratioUnitTestsAndMethods > 0.1){
		return "+";
	}else if (ratioUnitTestsAndMethods > 0.0){
		return "O";
	}else{
		return complexityScore;
	}
}
