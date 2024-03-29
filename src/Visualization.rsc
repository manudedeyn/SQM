module Visualization

import vis::Charts;
import Content;
import Helpers::Helpers;
import Metrics::UnitSize;


public Content visualizeScores(str volumeScore, str unitSizeScore, str unitComplexityScore, str duplicationScore, str analysabilityScore, str changabilityScore, str testabilityScore, str overallMaintainabilityScore){	
	rel[str label, num val] values = {<"volumeScore", getIntScore(volumeScore)>, <"unitSizeScore", getIntScore(unitSizeScore)>, <"unitComplexityScore", getIntScore(unitComplexityScore)>, <"duplicationScore", getIntScore(duplicationScore)>, <"analysabilityScore", getIntScore(analysabilityScore)>, <"changabilityScore", getIntScore(changabilityScore)>, <"testabilityScore", getIntScore(testabilityScore)>, <"overallMaintainabilityScore", getIntScore(overallMaintainabilityScore)>};

	//Content c = polarAreaChart(values, "Hier zou de Grafieknaam moeten komen.."); 	Ik krijg die functie niet werkend met custom grafieknaam.
	Content c = polarAreaChart(values);
	
	return c;
}

//Requirement: Metrics are calculated prior to calling this function.
public Content visualizeUnitSizeDetails(rel[num x, num y] values){	
	Content c = scatterChart(values); 
	return c;
}

public Content createCyclomaticComplexityChart(int simple, int moderate, int high, int veryHigh){
		rel[str label, num val] values = {<"Simple", simple>, <"Moderate", moderate>, <"High", high>, <"Very High", veryHigh>};
		str title = "Cyclomatic Complexity";
		Content c = createPieChart(values);
		return c;
} 

public Content createDuplication(int nonDuplication, int duplicated){
		rel[str label, num val] values = {<"Not duplicated", nonDuplication>, <"Duplicated", duplicated>};
		str title = "Duplication";
		Content c = createPieChart(values);
		return c;
} 

public Content createPieChart(rel[str label,num val] values){
		Content c = pieChart(values);
		return c;
}

