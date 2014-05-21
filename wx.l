%option noyywrap nodefault

%{
#include <stdbool.h>

int chars = 0;
int words = 0;
int lines = 0;

bool row_output = false;
bool line_output = false;
bool word_output = false;
bool char_output = false;
bool switch_present = false;
%}

%%

[a-zA-Z\']+ {	words++; chars += strlen(yytext); }   // '
\n		  { chars++; lines++; }
.		  { chars++; }

%%

int main(int argc, char **argv) {
	int i,c;

	while ((c = getopt (argc, argv, "clrw")) != -1){
		switch (c) {
			case 'c':
				char_output = true;
				switch_present = true;
				break;
			case 'l':
				line_output = true;
				switch_present = true;
				break;
			case 'r':
				row_output = true;
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
				printf("L: %d\t\t", lines);
			if (word_output)
				printf("W: %d\t\t", words);
			if (char_output)
				printf("C: %d", chars);
			printf("\n");
		}
		else { // long format
			printf("%s\n", argv[i]);
			if (line_output)
				printf("  Lines: %d\n", lines);
			if (word_output)
				printf("  Words: %d\n", words);
			if (char_output)
				printf("  Chars: %d\n", chars);
			printf("\n");
		}

		chars = 0;
		words = 0;
		lines = 0;
	}

}