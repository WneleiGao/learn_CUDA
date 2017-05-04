#include "/home/ywang15/Documents/cuda/cuda_by_examples/common/book.h"
#include "/home/ywang15/Documents/cuda/cuda_by_examples/common/cpu_bitmap.h"

#define len 200

struct cuComplex{
    float r;
    float i;

    cuComplex(float a, float b) : r(a), i(b) {}

    __device__ cuComplex operator*(cuComplex &c){
        real = r*a - i*b;
        imag = a*i + r*b;
        return cuComplex(real, imag);
    }

    __device__ cuComplx operator+(cuComplex &c){
        return cuComplex(r+c.r, i+c.i);
    }

    __device__ float magnitude2( void ){
        return r*r + i*i;
    }
}

__device__ int julia(int x, int y){
    const float scale = 1.5;
    const float tmp = (float)(len) / 2.0;
    float ix = scale * (tmp-x) / tmp;
    float iy = scale * (tmp-y) / tmp;

    cuComplex a(ix,iy), c(-0.8, 0.156);
    for (int i=0; i<200; i++){
        a = a*a + c;
    }
    if (a.magnitude2() > 1000.0){
        return 0;
    }
    return 1;
}

__global__ void kernal(unsigned char *ptr){
    int idx = blockIdx.x;
    int idy = blockIdx.y;
    int id  = idx + idy * gridDim.x;
    int value = julia(idx, idy);

    ptr[id*4 + 0] = 255 * value;
    ptr[id*4 + 1] = 0;
    ptr[id*4 + 2] = 0;
    ptr[id*4 + 3] = 255;
}

int main( void ){
    CPUBitMap bitmap(len, len);
    unsigned char *d_bmp;

    HANDLE_ERROR( cudaMalloc( (void**) &d_map, bitmap.image_size()  ) );
    dims3 grid(len, len);
    kernal<<<dims, 1>>>(d_bmp);

    HANDLE_ERROR( cudaMemcpy( bitmap.get_ptr(), d_map,
                              bitmap.image_size(), cudaMemcpyDeviceToHost ) );
    cudaFree(d_map);
    bitmap.display_and_exit();
    return 0;
}
