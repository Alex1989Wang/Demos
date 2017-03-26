#include <stdio.h>

int main() {
	
	float fahr, celsius;
	float low_bound, up_bound, step;

	low_bound = 0;
	up_bound = 300;
	step = 20;

	fahr = low_bound;
	do {
		celsius = (5.0 / 9.0) * (fahr - 32.0);
		printf ("fahr:%3.0f\tcelsius:%6.1f\n", fahr, celsius);
		fahr += step;	
			
	}while (fahr <= up_bound);
}	
