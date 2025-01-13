# Implementing difficulty indicators

<p> Generally, workout enthusiasts will recommend you gauge your workout intensity based on subjective measures while you're working out such as how deep you're breathing and how much you sweat. While *FitLife* wants to help you achieve your goals, you should do it in a healthy manner. We will promote healthy gains by allowing users to input their own exercise difficulty ratings to help them plan their schedule and avoid overexertion. Preloaded Exercises will have initial difficulty ratings, but once added to a Workout, can be customized by the users with the information on a more objective rating scale. That way, advanced users can have a higher granularity of control, and new users can have helpful and safe advice when toggling difficulty ratings (and can stick with the base ones if need be).

>...Another way to gauge your exercise intensity is to see how fast your heart is beating on average during physical activity. To use this method, you first have to figure out your maximum heart rate. The maximum heart rate is the upper limit of what your heart and blood vessel system, called the cardiovascular system, can handle during physical activity.
>
>If you're healthy, you can figure out your approximate maximum heart rate by multiplying your age by 0.7 and subtracting the total from 208. 
>
>For example, if you're 45 years old, multiply 45 by 0.7 to get 31.5, and subtract 31.5 from 208 to get a maximum heart rate of 176.5. 
>
>This is the average maximum number of times the heart should beat each minute during exercise in this example.
> The American Heart Association generally recommends these heart rate targets:
>- Moderate exercise intensity: 50% to about 70% of your maximum heart rate.
>- Vigorous exercise intensity: 70% to about 85% of your maximum heart rate.

*Fitlife*'s implementation of these guidelines will be as follows:

1. Warmup: a light exercise to get you moving
2. Moderate: a difficult exercise that does not cause significant exhaustion
3. Intense: an exercise that should use most of your physical exertion, and should be inconsistent in your Workout
</br>



<p>

[Reference regarding exercise vigor ratings](https://www.mayoclinic.org/healthy-lifestyle/fitness/in-depth/exercise-intensity/art-20046887)