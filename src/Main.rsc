module Main
import IO;
import Metrics::Volume;
import Metrics::UnitSize;
import Metrics::Duplication;
import Metrics::CyclomaticComplexity;
import util::Math;
import Helpers::Helpers;


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
	int percentageDuplicated = percent(getNumberOfDuplicateLinesForEachClassInProject(project), LOC); // <- Deze wordt nog verkeerd uitgerekend. Komt 160% uit, functie moet gefixt worden
	println("duplication: <percentageDuplicated>");
	println("");
	println("volume score: <manYearsScore(LOC)>");
	println("unit size score: <getUnitSizeScore(unitSizes)>");
	println("unit complexity score: <getUnitComplexityScore([simple,complexity[2],complexity[1],complexity[0]])>");
	println("duplication score: <getDuplicationRank(percentageDuplicated)>"); 
	println("");
	println("analysability score: " + "todo"); // TODO
	println("changability score: " + "todo"); // TODO
	println("testability score: " + "todo"); // TODO
	println("");
	println("overall maintainability score: " + "++++"); // TODO
}
