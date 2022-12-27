module Helpers::WhitespaceHelper

import IO;
import lang::java::m3::AST;
import String;



//removeWhitespace and comments for a file, can't do it per line, because multiline comments might span multiple lines
public list[str] removeWhitespaceAndComments(loc file){
	
	list[str] result = [];
	list[str] allFileLines = readFileLines(file);
	
	bool multiLineCommentActive = false;
	

	for(line <- allFileLines){
		line = trim(line);
		
		bool ignoreLine = false;
		
		
		//Is line a single line comment or situated within a multiline comment?
		if(startsWith(line,"//") || multiLineCommentActive == true){
			ignoreLine = true;
		};
		
		
		//Is line the start of a multi line comment?
		if(startsWith(line,"/*")){
			ignoreLine = true;
			multiLineCommentActive = true;
		};
		
		//Is line the end of a multi line comment?
		if(endsWith(line,"*/")){
		ignoreLine == true;
		multiLineCommentActive = false;
		};
		
		if(line == ""){
		 ignoreLine == true;
		}

		//Add line to resultSet if not a comment
		if(ignoreLine == false) {
		  result += [line];
		}
	}
	
	return result;
}