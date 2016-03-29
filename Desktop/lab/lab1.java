package lab;

import org.antlr.runtime.tree.CommonTree;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.io.*;
import java.util.*;

/*
 * @author Jonathan Johnson
 * CSCI 468 Lab 1 Scanner
 */

public class lab1 {
	public static void main(String[] args) throws Exception {
		
		StringBuilder file = new StringBuilder();
//		Scanner sc = null;
//		
//		try{
//			sc = new Scanner(new File("test1.micro"));
//		} catch (FileNotFoundException e){
//			System.out.println("Error!!");
//			System.exit(0);
//		}
		try (BufferedReader br = new BufferedReader(new FileReader(/*"test5.micro"*/args[0])))
		{
			String sCurrentLine;

			while ((sCurrentLine = br.readLine()) != null) {
				file.append(sCurrentLine + "\n");
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		String stuff = file.toString(); //file
		
		// generating antlr code
		ANTLRInputStream in = new ANTLRInputStream(stuff);
		tokenLexer lexer = new tokenLexer(in);
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		tokenParser parser = new tokenParser(tokens);		
		parser.start();
		
		//parser.setBuildParseTree(true);
		
		
		
		// printing the text input
		PrintWriter out = new PrintWriter(new FileWriter("output.txt"));
		boolean validParser = false; 

		
		int errors = parser.getNumberOfSyntaxErrors();
//		ParseTree tree = parser.start();
//		System.out.println(tree.toStringTree(parser));
		
		if (errors == 0){
			validParser = true;
		}
		
		if(validParser){
			out.println("Accepted");
		} else {
			out.println("Not accepted");
			//System.out.println(errors);
		}
//		for (int i = 0; i < tokens.size(); i++) {
//			if (tokens.get(i).getType() - 1 < 0) {
//				// do nothing
//			} else {
//				System.out.println("Token Type: " + lexer.getRuleNames()[tokens.get(i).getType() - 1]);
//				System.out.println("Value: " + tokens.get(i).getText().replaceAll("\n", ""));
//			}
//		}
		out.close();
	}
}
