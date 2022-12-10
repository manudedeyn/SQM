module Metrics::UnitSize

import IO;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import Prelude;
import Helpers::Helpers;
import Helpers::WhitespaceHelper;



public int GetUnitSize(loc unit) {
   	int totaalAantalRegels = 0;
   
   list[str] lines = removeWhitespaceAndComments(unit);
   
   	for (str a <- lines){
		totaalAantalRegels = totaalAantalRegels +1;
	}
	return totaalAantalRegels;
}


public void CalculateUnitSizes() {
   
loc project = |project://smallsql/|;
 
 
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
 
 
   println("numberOfLinesVeryHighRisk = <numberOfLinesVeryHighRisk>");
   println("numberOfLinesHighRisk = <numberOfLinesHighRisk>");
   println("numberOfLinesModerateRisk = <numberOfLinesModerateRisk>");
   println("numberOfLinesSimple = <numberOfLinesSimple>");
   println("Total amount of unit lines=<numberOfLinesVeryHighRisk+numberOfLinesHighRisk+numberOfLinesModerateRisk+numberOfLinesSimple>");
}