%option noyywrap nodefault

%{

// wx scanner (including the wx.l flex source and generated wx.c source file)
// Copyright 2014. Christopher Simpkins
// MIT License

#define WX_VERSION ("0.1.0")
#define WX_DEVELOPER ("Christopher Simpkins")
#define WX_YEAR ("2014")
#define WX_LICENSE ("MIT License")

#include <stdbool.h> // true and false values, bool type
#include <ctype.h>   // isprint() function

unsigned long chars = 0;
unsigned long words = 0;
unsigned long lines = 0;

bool row_output = false;     // single row output format flag
bool line_output = false;    // include line count output flag
bool word_output = false;    // include word count output flag
bool char_output = false;    // include character count output flag
bool switch_present = false; // user included a switch flag, used to display all when not present
bool pipe_output = false;    // user indicated output to be piped to another executable, remove the non-count text

void print_help();
void print_version();
%}

%%

[a-zA-Z\']+ {	words++; chars += strlen(yytext); }   // '
\n		  { chars++; lines++; }
.		  { chars++; }

%%

int main(int argc, char **argv) {
	int i,c;

	while ((c = getopt (argc, argv, "chlprvw")) != -1){
		switch (c) {
			case 'c':
				char_output = true;
				switch_present = true;
				break;
			case 'h':
				print_help();
				break;
			case 'l':
				line_output = true;
				switch_present = true;
				break;
			case 'p':
				pipe_output = true;
				break;
			case 'r':
				row_output = true;
				break;
			case 'v':
				print_version();
				break;
			case 'w':
				word_output = true;
				switch_present = true;
				break;
			case '?':
             if (isprint (optopt))
               fprintf (stderr, "Unknown option `-%c'.\n", optopt);
             else
               fprintf (stderr,
                        "Unknown option character `\\x%x'.\n",
                        optopt);
             return 1;
		}
	}

	if (optind == argc) {
		// error if there is no file included
		fprintf(stderr, "%s\n", "Missing file path.");
		return 1;
	}

	for (i=optind; i < argc; i++) {
		FILE *f = fopen(argv[i], "r");

		if (!f){
			perror(argv[i]);
			return 1;
		}

		yyrestart(f);
		yylex();
		fclose(f);

		// if there was not a char, line, or word switch, then display all output
		if (!switch_present) {
			word_output = true;
			line_output = true;
			char_output = true;
		}

		// print output - row output format
		if (row_output) {
			printf("%s\t", argv[i]);
			if (line_output)
				printf("L: %lu\t\t", lines);
			if (word_output)
				printf("W: %lu\t\t", words);
			if (char_output)
				printf("C: %lu", chars);
			printf("\n");
		}
		else { // print output - long output format
			// `pipe_output` flag is checked to determine whether to remove additional print text formatting for piped data to other executables
			if (!pipe_output){
				printf("%s\n", argv[i]);
			}
			if (line_output) {
				if (pipe_output){
					printf("%lu", lines);
					break;
				}
				else{
					printf("  Lines: %lu\n", lines);
				}
			}
			if (word_output) {
				if (pipe_output){
					printf("%lu", words);
					break;
				}
				else{
					printf("  Words: %lu\n", words);
				}
			}
			if (char_output) {
				if (pipe_output){
					printf("%lu", chars);
					break;
				}
				else{
					printf("  Chars: %lu\n", chars);
				}
			}
			if (!pipe_output){
				printf("\n");
			}

		}

		// reset the single file count values after data pushed to standard output for the file
		chars = 0;
		words = 0;
		lines = 0;
	}

}

// Functions

void print_help() {
	printf("\nwx\n");
	printf("---\n");
	printf("Description: Character, word, and line counts.\n\n");
	printf("Usage: wx [-clprw] <file-path>\n\n");
	printf("Options:\n");
	printf("\t-c : Calculate character count\n");
	printf("\t-l : Calculate line count\n");
	printf("\t-p : Only print value to standard out.  Use with -c, -l, or -w flag.\n");
	printf("\t-r : Print data to standard output in a compressed 'row' view\n");
	printf("\t-w : Calculate word count\n\n");
	exit(0);
}

void print_version(){
	printf("wx v%s\n", WX_VERSION);
	exit(0);
}
