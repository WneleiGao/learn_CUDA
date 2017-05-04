#include "/home/ywang15/Documents/cuda/cuda_by_examples/common/book.h"
#include <iostream.h>

#define N 3945384953
#define numThreads 256
#define numBlocks 256

__global__ void kernal(float *a, float *b, float *c){
    __shared__ float cache[numThreads];
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    int cid = threadIdx.x;
    float tmp;
    while (tid < N){
        tmp = a[tid] * b[tid];
        cache[cid] += tmp;
        tid = tid + numBlocks * numThreads;
    }
    __syncThreads();

    int iu = blockDim.x / 2;
    while (iu > 0){
        if (tid < iu){
           cache[tid] = cache[tid] + cache[tid+iu];
        }
        __syncThreads();
        iu = iu / 2;
    }
    if (threadIdx.x == 0){
        c[blockIdx] = cache[0];
    }
}

int main( void ){
    float *a, *b, *cpar, c;
    float *d_a, *d_b, *d_c;

    a = new float[N];
    // a  = (float *)malloc( N*sizeof(float));
    b = new float[N];
    cpar = new float[numBlocks];
    for (int i=0; i<N; i++){
        a[i] = i;
        b[i] = i;
    }
    HANDLE_ERROR( cudaMalloc( (void **)&d_a, sizeof(float)*N ) );
    HANDLE_ERROR( cudaMalloc( (void **)&d_b, sizeof(float)*N ) );
    HANDLE_ERROR( cudaMalloc( (void **)&d_c, sizeof(float)*numBlocks ) );

    kernal<<<numBlocks, numThreads>>>(d_a, d_b, d_c);

    HANDLE_ERROR( cudaMemcpy( d_a, a, size(float)*N, cudaMemcpyHostToDevice ) );
    HANDLE_ERROR( cudaMemcpy( d_b, b, size(float)*N, cudaMemcpyDeviceToHost ) );
    HANDLE_ERROR( cudaMemcpy( cpar, d_c, size(float)*numBlocks, cudaMemcpyDeviceToHost ) );

    float r;
    for (i=0; i<numBlocks; i++){
        r = r + cpar[i];
    }
    printf("final result %f\n", r);

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    delete [] a;
    delete [] b;
    delete [] cpar;

    return 0;

}
