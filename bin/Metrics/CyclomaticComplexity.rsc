module Metrics::CyclomaticComplexity


import IO;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;

import Metrics::UnitSize;
import Metrics::Volume;
import Prelude;


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



public void CalculateCC(){
 loc project = |project://smallsql/|;
 
 //reset counters
numberOfLinesVeryHighRisk = 0;
numberOfLinesHighRisk = 0;
numberOfLinesModerateRisk = 0;
numberOfLinesSimple = 0;

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
 
 
   println("numberOfLinesVeryHighRisk = <numberOfLinesVeryHighRisk>");
   println("numberOfLinesHighRisk = <numberOfLinesHighRisk>");
   println("numberOfLinesModerateRisk = <numberOfLinesModerateRisk>");
   println("numberOfLinesSimple = <numberOfLinesSimple>");
   println("Total amount of lines=<metricVolumeLOC>");
   println("");
   println("");
   println("Percentage of lines at very high risk: <numberOfLinesVeryHighRisk/metricVolumeLOC()*100>%");
   println("Percentage of lines at high risk:  <numberOfLinesHighRisk/metricVolumeLOC()*100>%");
   println("Percentage of lines at moderate risk:  <numberOfLinesModerateRisk/metricVolumeLOC()*100>%");
   println("Percentage of lines at low risk:  <numberOfLinesSimple/metricVolumeLOC()*100>%");
   
}
