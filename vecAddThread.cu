#include "/home/ywang15/Documents/cuda/cuda_by_examples/common/book.h"
#include <iostream>

#define N 876982349

__global__ void add(int *a, int *b, int *c){
    id = threadIdx.x + blockIdx.x * blockDim.x;
    if (id < N){
        c[id] = a[id] + b[id];
        id = id + blockDim.x * gridDim.x;
    }
}

void main(void){
    int a[N], b[N], c[N];
    int *d_a, *d_b, *d_c;

    for (int i=0; i<N; i++){
        a[i] = i+1;
        b[i] = 2*(i+1);
    }

    HANDLE_ERROR( cudaMalloc( (void **)&d_a, sizeof(int)*N ) );
    HANDLE_ERROR( cudaMalloc( (void **)&d_b, sizeof(int)*N ) );
    HANDLE_ERROR( cudaMalloc( (void **)&d_c, sizeof(int)*N ) );

    HANDLE_ERROR( cudaMemcpy(d_a, a, sizeof(int)*N, cudaMemcpyHostToDevice) );
    HANDLE_ERROR( cudaMemcpy(d_b, b, sizeof(int)*N, cudaMemcpyHostToDevice) );

    add<<<128, 128>>>(d_a, d_b, d_c);
    HANDLE_ERROR( cudaMemcpy(c, d_c, sizeof(int)*N, cudaMemcpyDeviceToHost) );

    for (int i=0; i<N; i++){
        if (a[i]+b[i] != c[i]){
            printf("%d + %d != %d\n", a[i], b[i], c[i]);
            printf("program failed!\n");
        }
    }

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
}
