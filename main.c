#include <stdio.h>
#include <string.h>
#include <assert.h>

extern void loadn(void *src, unsigned int len, void *dest);

int main(void)
{
	int i, len;
	char data[16] = { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16 };
	char dest[16];
	char expect[16];

	for (i = 0; i < 16; i++) {
		for (len = 0; len <= 8 && i + len <= 16; len++) {
			fprintf(stderr, "Offset %d, length %d ... ", i, len);
			loadn(data + i, len, dest);
			memcpy(expect, data + i, len);
			fprintf(stderr, "%s\n",
				memcmp(dest, expect, len) == 0 ? "ok" : "oops");
		}
	}

	return 0;
}
