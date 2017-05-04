#define INF 2e10f

struct Sphere{
    float x;
    float y;
    float z;
    float radius;
    float r;
    float g;
    float b;
    __device__ float hit(float ox, float oy, float *n){
        float dx = abs(ox-x);
        float dy = abs(oy-y);
        float d  = sqrt(dx*dx + dy*dy);
        if (d < radius){
           dz = sqrt(radius*radius - d*d);
           *n = dz / radius;
           return dz + z;
        }
        return INF
    }
}
