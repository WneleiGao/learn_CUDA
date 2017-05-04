#include "/home/ywang15/Documents/cuda/cuda_by_examples/common/book.h"
#include <iostream>

#define N 100

__global__ void add(int *a, int *b, int *c){
    tid = blockIdx.x;
    c[tid] = a[tid] + b[tid];
}

void main(void){
    int a[N], b[N], c[N];
    int *d_a, *d_b, *d_c;

    for (int i=0; i<N; i++){
        a[i] = i+1;
        b[i] = i+1;
    }

    HANDLE_ERROR( cudaMalloc( (void **)&d_a, sizeof(int)*N ) );
    HANDLE_ERROR( cudaMalloc( (void **)&d_b, sizeof(int)*N ) );
    HANDLE_ERROR( cudaMalloc( (void **)&d_c, sizeof(int)*N ) );

    HANDLE_ERROR( cudaMemcpy(d_a, a, sizeof(int)*N, cudaMemcpyHostToDevice) );
    HANDLE_ERROR( cudaMemcpy(d_b, b, sizeof(int)*N, cudaMemcpyHostToDevice) );

    add<<<N, 1>>>(d_a, d_b, d_c);
    HANDLE_ERROR( cudaMemcpy(c, d_c, sizeof(int)*N, cudaMemcpyDeviceToHost) );

    for (int i=0; i<N; i++){
        printf("%d + %d = %d\n", a[i], b[i], c[i]);
    }

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
}
