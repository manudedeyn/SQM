module Metrics::CyclomaticComplexity


import IO;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;

import Metrics::UnitSize;
import Metrics::Volume;
import Prelude;
import util::Math;


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
					println("Complexity:<complexity>   , Unit Size:<unitSize>");
					
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
					println("Complexity:<complexity>   , Unit Size:<unitSize>");
					
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
 
   
   numberOfLines = metricVolumeLOC();
   println("numberOfLinesVeryHighRisk = <numberOfLinesVeryHighRisk>");
   println("numberOfLinesHighRisk = <numberOfLinesHighRisk>");
   println("numberOfLinesModerateRisk = <numberOfLinesModerateRisk>");
   println("numberOfLinesSimple = <numberOfLinesSimple>");
   println("Total amount of lines=<numberOfLines>");
   println("");
   println("");
   println("Percentage of lines at very high risk: <numberOfLinesVeryHighRisk/numberOfLines*100>%");
   println("Percentage of lines at high risk:  <numberOfLinesHighRisk/numberOfLines*100>%");
   println("Percentage of lines at moderate risk:  <numberOfLinesModerateRisk/numberOfLines*100>%");
   println("Percentage of lines at low risk:  <numberOfLinesSimple/numberOfLines*100>%");
   return [toInt(numberOfLinesVeryHighRisk/numberOfLines*100), toInt(numberOfLinesHighRisk/numberOfLines*100), toInt(numberOfLinesModerateRisk/numberOfLines*100), toInt(numberOfLinesSimple/numberOfLines*100)];
   
}
