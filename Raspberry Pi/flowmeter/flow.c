#include <stdio.h>

#include <pigpio.h>

// #define HALL 14
#define HALL 18

int count;

void alert(int gpio, int level, uint32_t tick)
{
   static uint32_t lastTick=0;

   if (lastTick) {
      //printf("%d %.2f\n", level, (float)(tick-lastTick)/1000000.0);
      // count++; // count should go here I think. still working on this
   }
   else {
	//printf("%d 0.00\n", level);
	//count++;
  }

   lastTick = tick;
   count++;
}

int main(int argc, char *argv[])
{
   int secs=60;

   if (argc>1)
      secs = atoi(argv[1]); /* program run seconds */

   if ((secs<1) || (secs>3600))
      secs = 3600;

   if (gpioInitialise()<0)
      return 1;

   gpioSetMode(HALL, PI_INPUT);

   gpioSetPullUpDown(HALL, PI_PUD_UP);

   gpioSetAlertFunc(HALL, alert);

   sleep(secs);

   printf("%d\n", count);

   gpioTerminate();
}
