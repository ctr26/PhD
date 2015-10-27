s_per_ms = 100
exposure = 40
piezo=0

Y_mirror = seq(0,1,length=(exposure*s_per_ms))
Z_mirror = matrix(piezo,(exposure*s_per_ms))

plot(sin(seq(0,2*pi,length=1000)))
plot(Y_mirror)
matplot(Z_mirror,add=T)