module Metrics::Volume

import Helpers::Helpers;
import Metrics::UnitSize;

//Volume metric 1 as defined by the SIG, the total number of lines of code




public int metricVolumeLOC() {

   loc project = |project://smallsql/|;
   set[loc] bestanden = javaBestanden(project);
   
	int totaalAantalRegels = 0;
	
    for(loc l <- bestanden){
        //Unit in this case corresponds to a file
    	totaalAantalRegels = totaalAantalRegels + GetUnitSize(l);
    }

	return totaalAantalRegels;
}




//Volume metric 2 as defined by the SIG, calculating the amount of man years it takes to create the software and directly scoring this

public int manyearsscore() {
	// Classify the lines of code into a score, where 5 is the best score, and 1 the worst score.
	
	int KLOC = metricVolumeLOC() / 1000;
	
	if(KLOC < 66) {
		return 5;
	}
	
	if(KLOC < 246) {
		return 4;
	}
	
	if(KLOC < 665) {
		return 3;
	}
	
	if(KLOC < 1310) {
		return 2;
	} else return 1;
	

}
