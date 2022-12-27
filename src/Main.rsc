module Main
import IO;
import Metrics::Volume;
import Metrics::UnitSize;
import Metrics::Duplication;
import Metrics::CyclomaticComplexity;
import util::Math;
import Helpers::Helpers;
import Metrics::Maintainability;


public void calculateMetrics(){
	
	loc project = |project://smallsql/|;
	println("SmallSQL");
	int LOC = metricVolumeLOC(project);
	println("lines of code: <LOC>");

	//Total, VeryHigh, High, Moderate, Low
	list[int] unitSizes = CalculateUnitSizes(project);
	println("number of units: <unitSizes[0]>");
	println("unit size:");
	println("   * simple: " + "<unitSizes[4]>" +"%");
	println("   * moderate: " + "<unitSizes[3]>" +"%");
	println("   * high: " + "<unitSizes[2]>" +"%");
	println("   * very high: " + "<unitSizes[1]>" +"%");
	list[int] complexity = CalculateCC(project); //returns in order: VeryHighRisk, HighRisk, ModerateRisk, LowRisk	
	int simple = 100-complexity[2]-complexity[1]-complexity[0];//Fix for complexities not being 100
	println("unit complexity:");
	println("   * simple: " + "<simple>" +"%");
	println("   * moderate: " + "<complexity[2]>" +"%");
	println("   * high: " + "<complexity[1]>" +"%");
	println("   * very high: " + "<complexity[0]>" +"%");
	int percentageDuplicated = percent(getNumberOfDuplicateLinesForEachClassInProject(project), LOC); 
	println("duplication: <percentageDuplicated>" +"%");
	println("");
	
	str volumeScore = manYearsScore(LOC);
	println("volume score: " + volumeScore);
	
	str unitSizeScore = getUnitSizeScore(unitSizes);
	println("unit size score: " + unitSizeScore);
	
	str unitComplexityScore = getUnitComplexityScore([simple,complexity[2],complexity[1],complexity[0]]);//Weighted
	println("unit complexity score: " + unitComplexityScore);
	
	str duplicationScore =  getDuplicationRank(percentageDuplicated);
	println("duplication score: " + duplicationScore); 
	println("");
	
	str testabilityScore = getTestabilityScore(project, unitComplexityScore);
	str analysabilityScore = getAnalysabilityScore(volumeScore, duplicationScore, unitSizeScore, testabilityScore);
	println("analysability score: " + analysabilityScore); 
	str changabilityScore = getChangabilityScore(unitComplexityScore, duplicationScore);
	println("changability score: " + changabilityScore); 
	println("testability score: " + testabilityScore); 
	println("");
	/*
	All of the above are considered to calculate overallMaintainabilityScore
	Weighted equally and rounded to floor:
	AnalysabilityScore
	ChangabilityScore
	TestabilityScore
	*/
	println("overall maintainability score: " + calculateAverageScore([analysabilityScore,changabilityScore, testabilityScore])); 
}
