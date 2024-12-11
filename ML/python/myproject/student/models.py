from django.db import models



class Position(models.Model):
    title = models.CharField(max_length=50)

    def __str__(self):
        return self.title
class Country(models.Model):
    county_name = models.CharField(max_length=50)

    def __str__(self):
        return self.county_name
class State(models.Model):
    state_name = models.CharField(max_length=50)
    def __str__(self):
        return self.state_name       
class City(models.Model):
    city_name = models.CharField(max_length=50)
    def __str__(self):
        return self.city_name
class Student(models.Model):
    fullname = models.CharField(max_length=100)
    emp_code = models.CharField(max_length=3)
    mobile= models.CharField(max_length=15)
    position= models.ForeignKey(Position,on_delete=models.CASCADE)
    county_name= models.ForeignKey(Country,on_delete=models.CASCADE)
    state_name= models.ForeignKey(State,on_delete=models.CASCADE)
    city_name= models.ForeignKey(City,on_delete=models.CASCADE)    
 