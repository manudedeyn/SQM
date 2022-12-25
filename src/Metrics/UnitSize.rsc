module Metrics::UnitSize

import IO;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import Prelude;
import Helpers::Helpers;
import Helpers::WhitespaceHelper;
import util::Math;


public int GetUnitSize(loc unit) {
   	int totaalAantalRegels = 0;
   
   list[str] lines = removeWhitespaceAndComments(unit);
   
   	for (str a <- lines){
		totaalAantalRegels = totaalAantalRegels +1;
	}
	return totaalAantalRegels;
}

//Returns the percentage of unit size in the following order: VeryHighRisk, HighRisk, ModerateRisk, LowRisk
public list[int] CalculateUnitSizes(loc project) {
 
int numberOfLinesVeryHighRisk = 0;
int numberOfLinesHighRisk = 0;
int numberOfLinesModerateRisk = 0;
int numberOfLinesSimple = 0;

 M3 model = createM3FromEclipseProject(project);
 	for(decl <- model.declarations) {
	
	
	
		if(isMethod(decl.name)) {
		
		ast = createAstFromFile(toLocation(decl.src.uri), false);
		
		int complexity = 0;
	
		visit(ast) {
			case m:\method(_,_,_,_,imp): {
				if(m.src == decl.src) { 
				int unitSize =  GetUnitSize(decl.src);
					if(unitSize<11) numberOfLinesSimple = numberOfLinesSimple += unitSize; 
					if(unitSize > 10 && unitSize<21) numberOfLinesModerateRisk = numberOfLinesModerateRisk += unitSize; 
					if(unitSize > 20 && unitSize<51) numberOfLinesHighRisk = numberOfLinesHighRisk += unitSize; 
					if(unitSize>51) numberOfLinesVeryHighRisk = numberOfLinesVeryHighRisk += unitSize; 
				}
			}
			case c:\constructor(_,_,_,imp): {
				if(c.src == decl.src) {
				int unitSize =  GetUnitSize(decl.src);
									if(unitSize<11) numberOfLinesSimple = numberOfLinesSimple += unitSize; 
					if(unitSize > 10 && unitSize<21) numberOfLinesModerateRisk = numberOfLinesModerateRisk += unitSize; 
					if(unitSize > 20 && unitSize<51) numberOfLinesHighRisk = numberOfLinesHighRisk += unitSize; 
					if(unitSize>51) numberOfLinesVeryHighRisk = numberOfLinesVeryHighRisk += unitSize; 
				}
			}
			
 		}
					
	}	
 	} 	
 
   numberOfLines = numberOfLinesVeryHighRisk+numberOfLinesHighRisk+numberOfLinesModerateRisk+numberOfLinesSimple;
   int veryHighRiskPercentage = percent(numberOfLinesVeryHighRisk, numberOfLines);
   int highRiskPercentage = percent(numberOfLinesHighRisk, numberOfLines);
   int moderateRiskPercentage = percent(numberOfLinesModerateRisk, numberOfLines);
   int lowRiskPercentage = percent(numberOfLinesSimple, numberOfLines);
   return [numberOfLines, veryHighRiskPercentage, highRiskPercentage, moderateRiskPercentage, lowRiskPercentage];//Total, VeryHigh, High, Moderate, Low
}

//This is calculated with a Weighted Average
public str getUnitSizeScore(list[int] values){
	//Left to right: Simple to VeryHigh
	list[real] weights = [1.0, 10.0, 20.0, 100.0];
	list[real] realValues = [toReal(values[4]), toReal(values[3]), toReal(values[2]), toReal(values[1])];	
	real avg = weighted_average(realValues, weights);
	//println(avg); 
		
	//Less is better here, so:
	str ret = "O";
	if (avg<= 10){
		return "++";
	}
	else if(avg<=10){
		return "+";
	}else if (avg<=25){
		return "O";
	}
	else if (avg<=40){
		return "-";
	}else{
		return "--";
	}
}
