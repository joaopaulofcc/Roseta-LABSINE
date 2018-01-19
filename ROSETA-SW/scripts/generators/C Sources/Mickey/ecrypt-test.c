#define QUOTE(str) QUOTE_HELPER(str)
#define QUOTE_HELPER(str) # str

#define ECRYPT_API ecrypt-sync.h

#include "ecrypt-portable.h"
#include QUOTE(ECRYPT_API)

#include <stdio.h>
#include <stdlib.h>

#define MAXKEYSIZEB ((ECRYPT_MAXKEYSIZE + 7) / 8)
#define MAXIVSIZEB  ((ECRYPT_MAXIVSIZE  + 7) / 8)



/* ------------------------------------------------------------------------- */

void run(FILE *fd, int keysize, int ivsize, u8* key, u8* iv, int length)
{

  ECRYPT_ctx ctx;

  /* Load key */
  ECRYPT_keysetup(&ctx, key, keysize, ivsize);
  ECRYPT_ivsetup(&ctx, iv);

  /* Generate new key and iv from keystream */
  ECRYPT_keystream_bytes(&ctx, key, length);

}


/* ------------------------------------------------------------------------- */

int main(int argc, char *argv[])
{

  int keysize = 80;
  int ivsize  = 80;


  u8 key[MAXKEYSIZEB]   = {atoi(argv[2]), atoi(argv[3]), atoi(argv[4]), atoi(argv[5]),  atoi(argv[6]), \
                           atoi(argv[7]), atoi(argv[8]), atoi(argv[9]), atoi(argv[10]), atoi(argv[11])};

  u8 iv[MAXIVSIZEB]     = {atoi(argv[12]), atoi(argv[13]), atoi(argv[14]), atoi(argv[15]), atoi(argv[16]), \
                           atoi(argv[17]), atoi(argv[18]), atoi(argv[19]), atoi(argv[20]), atoi(argv[21])};


  ECRYPT_init();

  run(stdout, keysize, ivsize, key, iv, atoi(argv[1]));

  return 0;
}
