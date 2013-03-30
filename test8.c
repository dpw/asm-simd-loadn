#include <stdio.h>
#include <string.h>
#include <assert.h>

extern void loadn8(void *src, unsigned int len, void *dest);

int main(void)
{
	int i, len, ok, failures;
	char data[16] = { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16 };
	char dest[16];
	char expect[16];

	failures = 0;

	for (i = 0; i < 16; i++) {
		for (len = 0; len <= 8 && i + len <= 16; len++) {
			fprintf(stderr, "Offset %d, length %d ... ", i, len);
			loadn8(data + i, len, dest);
			memcpy(expect, data + i, len);

			ok = !memcmp(dest, expect, len);
			failures += !ok;
			fprintf(stderr, "%s\n", ok == 0 ? "ok" : "oops");
		}
	}

	fprintf(stderr, "%d failures\n", failures);
	return failures != 0;
}
