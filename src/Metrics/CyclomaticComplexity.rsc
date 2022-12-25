module Metrics::CyclomaticComplexity


import IO;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;

import Metrics::UnitSize;
import Metrics::Volume;
import Prelude;
import util::Math;
import Helpers::Helpers;


// Calculates the Cyclomatic Complexity metric

public int calcCCOfStatement(Statement statement){
    int result = 1;
	 visit (statement) {
        case \if(_,_) : result += 1;
        case \if(_,_,_) : result += 1;
        case \case(_) : result += 1;
        case \do(_,_) : result += 1;
        case \while(_,_) : result += 1;
        case \for(_,_,_) : result += 1;
        case \for(_,_,_,_) : result += 1;
        case foreach(_,_,_) : result += 1;
        case \catch(_,_): result += 1;
        case \conditional(_,_,_): result += 1;
        case infix(_,"&&",_) : result += 1;
        case infix(_,"||",_) : result += 1;
    }
    
    return result;
}


//Example usage: CalculateCC(|project://smallsql/|);
//Returns the percentage of lines with a certain risk in the following order: VeryHighRisk, HighRisk, ModerateRisk, LowRisk
public list[int] CalculateCC(loc project){ 
//reset counters
numberOfLinesVeryHighRisk = 0.0;
numberOfLinesHighRisk = 0.0;
numberOfLinesModerateRisk = 0.0;
numberOfLinesSimple = 0.0;

 M3 model = createM3FromEclipseProject(project);
 	for(decl <- model.declarations) {
	
	
	
		if(isMethod(decl.name)) {
		
		ast = createAstFromFile(toLocation(decl.src.uri), false);
		
		int complexity = 0;
	
		visit(ast) {
			case m:\method(_,_,_,_,imp): {
				if(m.src == decl.src) { 
					int complexity = calcCCOfStatement(imp);
					int unitSize =  GetUnitSize(decl.src);
					//println("Complexity:<complexity>   , Unit Size:<unitSize>");
					
					//Add LOC to the correct counters
					if(complexity<11) numberOfLinesSimple = numberOfLinesSimple += unitSize; 
					if(complexity > 10 && complexity<21) numberOfLinesModerateRisk = numberOfLinesModerateRisk += unitSize; 
					if(complexity > 20 && complexity<51) numberOfLinesHighRisk = numberOfLinesHighRisk += unitSize; 
					if(complexity>51) numberOfLinesVeryHighRisk = numberOfLinesVeryHighRisk += unitSize; 
					
				}
			}
			case c:\constructor(_,_,_,imp): {
				if(c.src == decl.src) {
					int complexity = calcCCOfStatement(imp);
					int unitSize =  GetUnitSize(decl.src);
					//println("Complexity:<complexity>   , Unit Size:<unitSize>");
					
					//Add LOC to the correct counters
					if(complexity<11) numberOfLinesSimple = numberOfLinesSimple += unitSize; 
					if(complexity > 10 && complexity<21) numberOfLinesModerateRisk = numberOfLinesModerateRisk += unitSize; 
					if(complexity > 20 && complexity<51) numberOfLinesHighRisk = numberOfLinesHighRisk += unitSize; 
					if(complexity>51) numberOfLinesVeryHighRisk = numberOfLinesVeryHighRisk += unitSize; 
				}
			}
			
 		}
					
	}	
 	} 	
 
   
   numberOfLines = metricVolumeLOC(project);
   /*println("numberOfLinesVeryHighRisk = <numberOfLinesVeryHighRisk>");
   println("numberOfLinesHighRisk = <numberOfLinesHighRisk>");
   println("numberOfLinesModerateRisk = <numberOfLinesModerateRisk>");
   println("numberOfLinesSimple = <numberOfLinesSimple>");
   println("Total amount of lines=<numberOfLines>");
   println("");
   println("");
   println("Percentage of lines at very high risk: <numberOfLinesVeryHighRisk/numberOfLines*100>%");
   println("Percentage of lines at high risk:  <numberOfLinesHighRisk/numberOfLines*100>%");
   println("Percentage of lines at moderate risk:  <numberOfLinesModerateRisk/numberOfLines*100>%");
   println("Percentage of lines at low risk:  <numberOfLinesSimple/numberOfLines*100>%");*/
  
   return [toInt(numberOfLinesVeryHighRisk/numberOfLines*100), toInt(numberOfLinesHighRisk/numberOfLines*100), toInt(numberOfLinesModerateRisk/numberOfLines*100), toInt(numberOfLinesSimple/numberOfLines*100)];
   
}


//This is calculated with a Weighted Average
public str getUnitComplexityScore(list[int] values){
	//Left to right: Simple to VeryHigh
	list[real] weights = [1.0, 10.0, 20.0, 100.0];
	list[real] realValues = [toReal(values[0]), toReal(values[1]), toReal(values[2]), toReal(values[3])];	
	real avg = weighted_average(realValues, weights);
		
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

public void test_getUnitComplexityScore(){
	println("unit complexity score simple 90, complex 10 : <getUnitComplexityScore([90,0,0,10])>"); //Expect ++
	println("unit complexity score simple 50, complex 50 : <getUnitComplexityScore([50,0,0,50])>"); //Expect -
	println("unit complexity score simple 10, complex 90 : <getUnitComplexityScore([10,0,0,90])>"); //Expect --
}
