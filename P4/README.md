# ECSE - 425 Project P4: Pipelined Processor

This deliverable consists of a pipelined implementation, in VHDL, of a simplified MIPS processor. 

We implemented a standard five-stage pipelined 32-bit MIPS processor in VHDL.  A pipelined processor stores control signals and intermediate results associated with each executing instruction in pipeline registers between stage. 

## Generate the instruction code
To generate the instruction data, using the Driver provided in \Assembler:
1. Write your code in instructions.asm
2. Compile the assembler using `javac Driver.java`
3. Assemble using `java Driver instructions.asm`
4. Move the generated program.txt file in the root folder

## Running the program
1. Create a new project in ModelSim
2. Add all the existing files
3. Run `source testbench.tcl`

## Authors
Arthur Kuhn
Ammar Sarfaraz Aziz
Dillon Keshwani
Kartik Puranik Karkala


## References
1. https://courses.cs.washington.edu/courses/cse378/09wi/lectures/lec08.pdf
2. http://db.cs.duke.edu/courses/fall11/cps104/lects/mips.pdf
3. https://github.com/armenism/ECSE425/blob/master/
4. https://github.com/chiwingsit/ECSE425/tree/master/


## NB

As of the submission deadline, some of our main function mapping still does not compile. We have tried to make each component as independant as possible to follow best practices. Integrating all the work proved much tougher and time consumming than expected.