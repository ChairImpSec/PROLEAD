#include <stdint.h>

uint32_t randomness __attribute__((section(".randomness")));
uint8_t plaintext[16] __attribute__((section(".data")));

//precomputed squaring table
uint8_t sq[256] = {
    0x00, 0x01, 0x04, 0x05, 0x10, 0x11, 0x14, 0x15,
    0x40, 0x41, 0x44, 0x45, 0x50, 0x51, 0x54, 0x55,
    0x1b, 0x1a, 0x1f, 0x1e, 0x0b, 0x0a, 0x0f, 0x0e,
    0x5b, 0x5a, 0x5f, 0x5e, 0x4b, 0x4a, 0x4f, 0x4e,
    0x6c, 0x6d, 0x68, 0x69, 0x7c, 0x7d, 0x78, 0x79,
    0x2c, 0x2d, 0x28, 0x29, 0x3c, 0x3d, 0x38, 0x39,
    0x77, 0x76, 0x73, 0x72, 0x67, 0x66, 0x63, 0x62,
    0x37, 0x36, 0x33, 0x32, 0x27, 0x26, 0x23, 0x22,
    0xab, 0xaa, 0xaf, 0xae, 0xbb, 0xba, 0xbf, 0xbe,
    0xeb, 0xea, 0xef, 0xee, 0xfb, 0xfa, 0xff, 0xfe,
    0xb0, 0xb1, 0xb4, 0xb5, 0xa0, 0xa1, 0xa4, 0xa5,
    0xf0, 0xf1, 0xf4, 0xf5, 0xe0, 0xe1, 0xe4, 0xe5,
    0xc7, 0xc6, 0xc3, 0xc2, 0xd7, 0xd6, 0xd3, 0xd2,
    0x87, 0x86, 0x83, 0x82, 0x97, 0x96, 0x93, 0x92,
    0xdc, 0xdd, 0xd8, 0xd9, 0xcc, 0xcd, 0xc8, 0xc9,
    0x9c, 0x9d, 0x98, 0x99, 0x8c, 0x8d, 0x88, 0x89,
    0x9a, 0x9b, 0x9e, 0x9f, 0x8a, 0x8b, 0x8e, 0x8f,
    0xda, 0xdb, 0xde, 0xdf, 0xca, 0xcb, 0xce, 0xcf,
    0x81, 0x80, 0x85, 0x84, 0x91, 0x90, 0x95, 0x94,
    0xc1, 0xc0, 0xc5, 0xc4, 0xd1, 0xd0, 0xd5, 0xd4,
    0xf6, 0xf7, 0xf2, 0xf3, 0xe6, 0xe7, 0xe2, 0xe3,
    0xb6, 0xb7, 0xb2, 0xb3, 0xa6, 0xa7, 0xa2, 0xa3,
    0xed, 0xec, 0xe9, 0xe8, 0xfd, 0xfc, 0xf9, 0xf8,
    0xad, 0xac, 0xa9, 0xa8, 0xbd, 0xbc, 0xb9, 0xb8,
    0x31, 0x30, 0x35, 0x34, 0x21, 0x20, 0x25, 0x24,
    0x71, 0x70, 0x75, 0x74, 0x61, 0x60, 0x65, 0x64,
    0x2a, 0x2b, 0x2e, 0x2f, 0x3a, 0x3b, 0x3e, 0x3f,
    0x6a, 0x6b, 0x6e, 0x6f, 0x7a, 0x7b, 0x7e, 0x7f,
    0x5d, 0x5c, 0x59, 0x58, 0x4d, 0x4c, 0x49, 0x48,
    0x1d, 0x1c, 0x19, 0x18, 0x0d, 0x0c, 0x09, 0x08,
    0x46, 0x47, 0x42, 0x43, 0x56, 0x57, 0x52, 0x53,
    0x06, 0x07, 0x02, 0x03, 0x16, 0x17, 0x12, 0x13};

//inversion in GF(256)
uint8_t inv[256] = {0x00, 0x01, 0x8d, 0xf6, 0xcb, 0x52, 0x7b, 0xd1,
				 0xe8, 0x4f, 0x29, 0xc0, 0xb0, 0xe1, 0xe5, 0xc7,
				 0x74, 0xb4, 0xaa, 0x4b, 0x99, 0x2b, 0x60, 0x5f,
				 0x58, 0x3f, 0xfd, 0xcc, 0xff, 0x40, 0xee, 0xb2,
				 0x3a, 0x6e, 0x5a, 0xf1, 0x55, 0x4d, 0xa8, 0xc9,
				 0xc1, 0x0a, 0x98, 0x15, 0x30, 0x44, 0xa2, 0xc2,
				 0x2c, 0x45, 0x92, 0x6c, 0xf3, 0x39, 0x66, 0x42,
				 0xf2, 0x35, 0x20, 0x6f, 0x77, 0xbb, 0x59, 0x19,
				 0x1d, 0xfe, 0x37, 0x67, 0x2d, 0x31, 0xf5, 0x69,
				 0xa7, 0x64, 0xab, 0x13, 0x54, 0x25, 0xe9, 0x09,
				 0xed, 0x5c, 0x05, 0xca, 0x4c, 0x24, 0x87, 0xbf,
				 0x18, 0x3e, 0x22, 0xf0, 0x51, 0xec, 0x61, 0x17,
				 0x16, 0x5e, 0xaf, 0xd3, 0x49, 0xa6, 0x36, 0x43,
				 0xf4, 0x47, 0x91, 0xdf, 0x33, 0x93, 0x21, 0x3b,
				 0x79, 0xb7, 0x97, 0x85, 0x10, 0xb5, 0xba, 0x3c,
				 0xb6, 0x70, 0xd0, 0x06, 0xa1, 0xfa, 0x81, 0x82,
				 0x83, 0x7e, 0x7f, 0x80, 0x96, 0x73, 0xbe, 0x56,
				 0x9b, 0x9e, 0x95, 0xd9, 0xf7, 0x02, 0xb9, 0xa4,
				 0xde, 0x6a, 0x32, 0x6d, 0xd8, 0x8a, 0x84, 0x72,
				 0x2a, 0x14, 0x9f, 0x88, 0xf9, 0xdc, 0x89, 0x9a,
				 0xfb, 0x7c, 0x2e, 0xc3, 0x8f, 0xb8, 0x65, 0x48,
				 0x26, 0xc8, 0x12, 0x4a, 0xce, 0xe7, 0xd2, 0x62,
				 0x0c, 0xe0, 0x1f, 0xef, 0x11, 0x75, 0x78, 0x71,
				 0xa5, 0x8e, 0x76, 0x3d, 0xbd, 0xbc, 0x86, 0x57,
				 0x0b, 0x28, 0x2f, 0xa3, 0xda, 0xd4, 0xe4, 0x0f,
				 0xa9, 0x27, 0x53, 0x04, 0x1b, 0xfc, 0xac, 0xe6,
				 0x7a, 0x07, 0xae, 0x63, 0xc5, 0xdb, 0xe2, 0xea,
				 0x94, 0x8b, 0xc4, 0xd5, 0x9d, 0xf8, 0x90, 0x6b,
				 0xb1, 0x0d, 0xd6, 0xeb, 0xc6, 0x0e, 0xcf, 0xad,
				 0x08, 0x4e, 0xd7, 0xe3, 0x5d, 0x50, 0x1e, 0xb3,
				 0x5b, 0x23, 0x38, 0x34, 0x68, 0x46, 0x03, 0x8c,
				 0xdd, 0x9c, 0x7d, 0xa0, 0xcd, 0x1a, 0x41, 0x1c};

uint8_t wshare[176] = {
    0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6,
    0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c,
    0xa0, 0xfa, 0xfe, 0x17, 0x88, 0x54, 0x2c, 0xb1,
    0x23, 0xa3, 0x39, 0x39, 0x2a, 0x6c, 0x76, 0x05,
    0xf2, 0xc2, 0x95, 0xf2, 0x7a, 0x96, 0xb9, 0x43,
    0x59, 0x35, 0x80, 0x7a, 0x73, 0x59, 0xf6, 0x7f,
    0x3d, 0x80, 0x47, 0x7d, 0x47, 0x16, 0xfe, 0x3e,
    0x1e, 0x23, 0x7e, 0x44, 0x6d, 0x7a, 0x88, 0x3b,
    0xef, 0x44, 0xa5, 0x41, 0xa8, 0x52, 0x5b, 0x7f,
    0xb6, 0x71, 0x25, 0x3b, 0xdb, 0x0b, 0xad, 0x00,
    0xd4, 0xd1, 0xc6, 0xf8, 0x7c, 0x83, 0x9d, 0x87,
    0xca, 0xf2, 0xb8, 0xbc, 0x11, 0xf9, 0x15, 0xbc,
    0x6d, 0x88, 0xa3, 0x7a, 0x11, 0x0b, 0x3e, 0xfd,
    0xdb, 0xf9, 0x86, 0x41, 0xca, 0x00, 0x93, 0xfd,
    0x4e, 0x54, 0xf7, 0x0e, 0x5f, 0x5f, 0xc9, 0xf3,
    0x84, 0xa6, 0x4f, 0xb2, 0x4e, 0xa6, 0xdc, 0x4f,
    0xea, 0xd2, 0x73, 0x21, 0xb5, 0x8d, 0xba, 0xd2,
    0x31, 0x2b, 0xf5, 0x60, 0x7f, 0x8d, 0x29, 0x2f,
    0xac, 0x77, 0x66, 0xf3, 0x19, 0xfa, 0xdc, 0x21,
    0x28, 0xd1, 0x29, 0x41, 0x57, 0x5c, 0x00, 0x6e,
    0xd0, 0x14, 0xf9, 0xa8, 0xc9, 0xee, 0x25, 0x89,
    0xe1, 0x3f, 0x0c, 0xc8, 0xb6, 0x63, 0x0c, 0xa6};



//IPM settings : constant public values

//uint8_t L[1][2] = {{0x01, 0x1b}};        // The orthogonal of n^2 matrix H
//uint8_t L_prime[1][2] = {{0x01, 0x1b}};  // orthogonal of H with the (k - 1) 0s removed (n - k +1)^2
//uint8_t L_hat[1][2][2] = {{{0x01, 0x1b}, {0x1b, 0x5e}}}; //L_prime*L_prime see algo IPM_Mult for details

uint8_t L[1][2];        // The orthogonal of n^2 matrix H
uint8_t L_prime[1][2];  // orthogonal of H with the (k - 1) 0s removed (n - k +1)^2
uint8_t L_hat[1][2][2]; //L_prime*L_prime see algo IPM_Mult for details

void randombytes(unsigned char *buf, uint32_t len){
    while(len>0){
        *buf = randomness;
        buf ++;
        len--;
    }
}

uint8_t multx(uint8_t x)
{
	uint8_t y = x;
	y = y << 1;
	// if((x & 0x80)!=0)  y=y ^ 0x1b;
	uint8_t m[] = {0, 0x1b};
	y ^= m[x >> 7];
	return y;
}

uint8_t GF256_Square(uint8_t x)
{
    return sq[x];
}

//Iterative constant time multiplication over GF(2^8) with unconditional reduction
//see paper "On the Performance and Security of Multiplication in GF(2^N)"
uint8_t GF256_Mult(uint8_t a, uint8_t b)
{
    int x = a, y = b, m, res = 0;
    unsigned char i;
    for (i = 0; i < 8; i++)
    {
        m = -(y & 1); //m is either 0xffff or 0x0000
        res ^= (x & m);
        y >>= 1;
        x <<= 1;
        //x must be reduced mod 0x011b = x^8+x^4+x^3+x+1
        m = -((x >> 8) & 1); //MSB
        x ^= (m & 0x1b);
    }
    return (uint8_t)res;
}

void IPM_Square(uint8_t *x2, const uint8_t *x, int position)
{
    int i;
    for (i = 1; i < 2; i++)
        x2[i] = GF256_Mult(GF256_Square(x[i]), L_prime[position][i]);
    x2[0] = GF256_Square(x[0]); //L_prime[position][0] = 1
}

uint8_t IPM_Homogenize(const uint8_t *Z, const uint8_t *Z_prime, int position)
{
    int i;
    uint8_t res = Z_prime[0];

    for (i = 1; i < 2; i++)
        res ^= GF256_Mult(L_prime[position][i], Z[i] ^ Z_prime[i]);
    return res;
}

//squaring of IPM_FD share, more efficient than Mult(x,x)
void IPM_FD_Square(uint8_t *Z2, const uint8_t *Z)
{
    int i, j;
    uint8_t P[1][2];
    uint8_t Q[0];

    uint8_t Z__[1][2];

    for (i = 0; i < 1; i++)
    {
        Z__[i][0] = Z[i];
        Z__[i][1] = Z[i+1];
    }
    for (j = 0; j < 1; j++)
        IPM_Square(P[j], Z__[j], j);


    for (j = 0; j < 1 - 1; j++)
        Q[j] = IPM_Homogenize(P[0], P[j + 1], j + 1);

    //return
    Z2[0] = P[0][0];
    Z2[1] = P[0][1];
    for (j = 0; j < 0; j++)
    {
        Z2[j + 1] = Q[j];
    }
}

uint8_t GF256_Inverse(uint8_t x)
{
	return inv[x];
}


//algo 2 : secure addition in IPM-FD
void IPM_FD_Add(uint8_t *res, const uint8_t *op1, const uint8_t *op2)
{
    int i;
    for (i = 0; i < 2; i++)
    {
        res[i] = op1[i] ^ op2[i];
    }
}

void IPM_Mult(uint8_t *P, const uint8_t *Z, const uint8_t *Z_prime, int position)
{

    //we have here n-k+1 compare to the original n in IPMsetup()
    int i, j;

    //step 1
    uint8_t A_hat[2][2];
    for (i = 0; i < 1; i++)
        randombytes(A_hat[i], 2);
    randombytes(A_hat[1], 1);

    uint8_t delta = 0;
    for (j = 0; j < 1; j++)
    {
        uint8_t sum = 0;
        for (i = 0; i < 2; i++)
        {
            sum ^= GF256_Mult(A_hat[i][j], L_hat[position][i][j]);
        }
        delta ^= sum;
    }

    uint8_t sum = 0;
    for (i = 0; i < 2 - 1; i++)
    {
        sum ^= GF256_Mult(A_hat[i][1], L_hat[position][i][1]);
    }
    A_hat[2 - 1][2 - 1] = GF256_Mult(delta ^ sum, GF256_Inverse(L_hat[position][1][1]));

    //step 2
    uint8_t R_hat[2][2];
    //save values for i,j in {k, N}

    for (i = 0; i < 2; i++)
    {
        for (j = 0; j < 2; j++)
            R_hat[i][j] = GF256_Mult(Z[i], Z_prime[j]);
    }

    //step 3
    uint8_t B_hat[2][2];
    for (i = 0; i < 2; i++)
    {
        for (j = 0; j < 2; j++)
        {
            B_hat[i][j] = R_hat[i][j] ^ A_hat[i][j];
        }
    }
    //step 4
    uint8_t b = 0;
    for (i = 1; i < 2; i++)
    {
        uint8_t tmp = 0;
        for (j = 0; j < 2; j++)
        {
            tmp ^= GF256_Mult(L_hat[position][i][j], B_hat[i][j]);
        }
        b ^= tmp;
    }
    //return
    P[0] = B_hat[0][0];
    P[1] = B_hat[0][1];
    P[0] ^= b;
}


void IPM_FD_Mult(uint8_t *R, const uint8_t *Z, const uint8_t *Z_prime)
{
    int i, j;
    uint8_t P[1][2];

    uint8_t Z__[1][2], Z_prime__[1][2]; //Z__[i] => i th in [0...k-1] coord of Z is kept, the other in [0...k-1] are dropped;

    for (i = 0; i < 1; i++)
    {
        Z__[i][0] = Z[i];
        Z__[i][1] = Z[i+1];
        Z_prime__[i][0] = Z_prime[i];
        Z_prime__[i][1] = Z_prime[i+1];
    }

    for (j = 0; j < 1; j++)
        IPM_Mult(P[j], Z__[j], Z_prime__[j], j);

    for (j = 1; j < 1; j++)
        P[j][0] = IPM_Homogenize(P[0], P[j], j);

    //return
    for (j = 0; j < 1; j++)
        R[j] = P[j][0];
    R[1] = P[0][1];
}

//Add constant value to masked vector
void IPConstAdd(uint8_t *res, const uint8_t *x, uint8_t c)
{
    res[1] = x[1];
    int i;
    for (i = 0; i < 1; i++)
        res[i] = x[i] ^ c;
}

//Multiply constant value to masked vector
void IPConstMult(uint8_t *res, const uint8_t *x, uint8_t c)
{
    int i;
    for (i = 0; i < 2; i++)
    {
        res[i] = GF256_Mult(x[i], c);
    }
}

/**
 * @brief Setup the IPM-FD masking scheme
 * 
 * @param n : the number of shares
 * @param k duplicating parameter for faults detection ( n > k)
 */
void IPM_FD_Setup()
{
    //if (n <= 0 || k <= 0 || n < k){
	//	printf("n > 0 should be greater than k > 0\n");
	//	exit(-1);
	//}
        
    int i = 0;

    int j;
    //use best known linear code for L (aka dual of H)


    L[0][0] = 1;
    L[0][1] = 27;

    for (j = 0; j < 1; j++)
    {
        L_prime[j][0] = 1;
        for (i = 1; i < 2; i++)
        {
            L_prime[j][i] = L[j][i];
        }
    }

    int p;
    for (p = 0; p < 1; p++)
    {
        for (i = 0; i < 2; i++)
        {
            for (j = 0; j < 2; j++)
            {
                L_hat[p][i][j] = GF256_Mult(L_prime[p][i], L_prime[p][j]);
            }
        }
    }
}

//raise sharing to the power 127
void x127_share(uint8_t *res, const uint8_t *x)
{
	// use 6 squarings and 4 multiplications, can we do better?
	uint8_t z[2];
	IPM_FD_Square(z, x); // z=x^2

	uint8_t y[2];
	IPM_FD_Mult(y, x, z); // y=z*x=x^3

	uint8_t w[2];
	IPM_FD_Square(w, y); //6

	IPM_FD_Mult(z, w, x); // z =x^7
	IPM_FD_Square(w, w);  // w=x^12

	uint8_t y2[2];
	IPM_FD_Mult(y2, w, y); // y2=x^15

	IPM_FD_Square(y2, y2); //30
	IPM_FD_Square(y2, y2); //60
	IPM_FD_Square(y2, y2); //120

	IPM_FD_Mult(res, y2, z); // y=x^127
}

//perform the sbox transformation on masked vector
//using sbox polynomial expression
//63 + 8fx^127 + b5x^191 + 01x^223 + f4x^239 + 25x^247 + f9x^251 + 09x^253 + 05x^254
void sbox_share(uint8_t *res, const uint8_t *x)
{
	uint8_t x254[2], x253[2], x251[2], x247[2], x239[2], x223[2], x191[2], x127[2];

	x127_share(x127, x);
	IPM_FD_Square(x254, x127);

	IPM_FD_Square(x253, x254);
	IPM_FD_Square(x251, x253); //251 = (253* 2)-255
	IPM_FD_Square(x247, x251);

	IPM_FD_Square(x239, x247);
	IPM_FD_Square(x223, x239); //x223 = (x239)^2
	IPM_FD_Square(x191, x223); //x^191 = (x^223)^2

	IPConstMult(x254, x254, 0x05);
	IPConstMult(x253, x253, 0x09);
	IPConstMult(x251, x251, 0xf9);

	IPConstMult(x247, x247, 0x25);
	IPConstMult(x239, x239, 0xf4);
	//IPConstMult(x223, x223,0x01, n);
	IPConstMult(x191, x191, 0xb5);
	IPConstMult(x127, x127, 0x8f);

	IPConstAdd(res, x127, 0x63);
	for (int i = 0; i < 2; i++)
		res[i] ^= x191[i] ^ x223[i] ^ x239[i] ^ x247[i] ^ x251[i] ^ x253[i] ^ x254[i];
}

//subbyte operation on masked state
void subbyte_share(uint8_t stateshare[16][2])
{
	int j;
	for (j = 0; j < 16; j++)
		sbox_share(stateshare[j], stateshare[j]);
}

void addroundkey_share(uint8_t stateshare[16][2], uint8_t wshare[176], int round)
{
	int i;
	for (i = 0; i < 16; i++)
		stateshare[i][0] ^= wshare[16 * round + i];
}



/**
 * @brief inner product between the mask M and param L
 *  
 * @param Z  = sum (L<i+k> * Mi)
 * @param M (the mask) has size = n-k
 */
void innerProduct(uint8_t *Z, const uint8_t *M)
{
    int i, j;
    for (j = 0; j < 1; j++)
    {
        Z[j] = 0;
        for (i = 0; i < 1; i++)
            Z[j] ^= GF256_Mult(L[j][i + 1], M[i]); //Field multiplication
    }
    for (i = 1; i < 2; i++)
        Z[i] = M[i - 1];
}

void mask(uint8_t *Z, uint8_t X)
{
    int i;
    uint8_t M[1]; //n - k random masks
    randombytes(M, 1);
    innerProduct(Z, M);
    for (i = 0; i < 1; i++)
        Z[i] ^= X; //duplicate the data
}


int unmask(const uint8_t Z[])
{
    int i, j;
    uint8_t res[1] = {0};

    for (j = 0; j < 1; j++)
    {
        for (i = 0; i < 2; i++)
            res[j] ^= GF256_Mult(L[j][i], Z[i]);
    }

    return res[0];
}

void shiftrows_share(uint8_t stateshare[16][2])
{
	uint8_t m;
	int i;
	for (i = 0; i < 2; i++)
	{
		m = stateshare[1][i];
		stateshare[1][i] = stateshare[5][i];
		stateshare[5][i] = stateshare[9][i];
		stateshare[9][i] = stateshare[13][i];
		stateshare[13][i] = m;

		m = stateshare[2][i];
		stateshare[2][i] = stateshare[10][i];
		stateshare[10][i] = m;
		m = stateshare[6][i];
		stateshare[6][i] = stateshare[14][i];
		stateshare[14][i] = m;

		m = stateshare[3][i];
		stateshare[3][i] = stateshare[15][i];
		stateshare[15][i] = stateshare[11][i];
		stateshare[11][i] = stateshare[7][i];
		stateshare[7][i] = m;
	}
}

void mixcolumns_share(uint8_t stateshare[16][2])
{
	uint8_t ns[16];
	int i, j;
	for (i = 0; i < 2; i++)
	{
		for (j = 0; j < 4; j++)
		{
			ns[j * 4] = multx(stateshare[j * 4][i]) ^ multx(stateshare[j * 4 + 1][i]) ^ stateshare[j * 4 + 1][i] ^ stateshare[j * 4 + 2][i] ^ stateshare[j * 4 + 3][i];
			ns[j * 4 + 1] = stateshare[j * 4][i] ^ multx(stateshare[j * 4 + 1][i]) ^ multx(stateshare[j * 4 + 2][i]) ^ stateshare[j * 4 + 2][i] ^ stateshare[j * 4 + 3][i];
			ns[j * 4 + 2] = stateshare[j * 4][i] ^ stateshare[j * 4 + 1][i] ^ multx(stateshare[j * 4 + 2][i]) ^ multx(stateshare[j * 4 + 3][i]) ^ stateshare[j * 4 + 3][i];
			ns[j * 4 + 3] = multx(stateshare[j * 4][i]) ^ stateshare[j * 4][i] ^ stateshare[j * 4 + 1][i] ^ stateshare[j * 4 + 2][i] ^ multx(stateshare[j * 4 + 3][i]);
		}
		for (j = 0; j < 16; j++)
			stateshare[j][i] = ns[j];
	}
}

__attribute__((noreturn, noinline)) void report_done()
{
    report_done();
}

void __attribute__((noinline)) initialize_local(uint8_t local[16], uint8_t uart[16]){
    for(int i = 0; i < 16; ++i){
        local[i] = uart[i];
    }
}

void cipher(uint8_t p_in[16]){

	IPM_FD_Setup(); //reduce this even more as it can be precomputed

	int i;


	int round = 0;
	uint8_t stateshare[16][2];

	for (i = 0; i < 16; i++)
	{
		mask(stateshare[i], p_in[i]);
	}

	addroundkey_share(stateshare, wshare, 0);


	//for (round = 1; round < 10; round++)
	//{

		subbyte_share(stateshare);
		shiftrows_share(stateshare);
		mixcolumns_share(stateshare);
		addroundkey_share(stateshare, wshare, 1);
	/*}

	subbyte_share(stateshare);
	shiftrows_share(stateshare);
	addroundkey_share(stateshare, wshare, 10);*/


	for (i = 0; i < 16; i++)
	{ 
		p_in[i] = unmask(stateshare[i]);
	}



}

int main()
{

    uint8_t p_in[16];

    initialize_local(p_in, plaintext);

    cipher(p_in);


    initialize_local(plaintext, p_in);

    report_done();

	return 0;
}