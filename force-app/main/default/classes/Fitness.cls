public class Fitness {
    public Decimal calculateBMI(Integer weight, Decimal height){
        Decimal bmivar = weight/(height*3.28) *2;
        return bmivar.setscale(2);
    }
    public Decimal calculatePace(Integer distance, Integer timevar){
        Decimal pacear = distance/timevar;
        return pacear.setscale(2);
    }

}