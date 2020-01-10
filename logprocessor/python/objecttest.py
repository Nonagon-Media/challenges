"""Object examples in python."""


# Public functions
def get_biggest_number(*args):
    """Return the largest number of passed in numbers."""
    return max(args)


def oldest_dog(dog_age_list):
    """Function that tells the oldest dog."""
    dog_age_list.sort()
    print("Oldest dog is: ", dog_age_list[-1])


# Class definitions
class Dog:
    """Example of a dog class."""

    # Class attribute. All instances of dog will have this
    species = 'mammal'

    # Initialization
    def __init__(self, name, age, breed):
        """Initialization of Dog instances."""
        self.name = name
        self.age = age
        self.breed = breed

    # Callable values
    def get_age(self):
        """Get dogs age."""
        return(self.age)

    def get_name(self):
        """Get dogs name."""
        return(self.name)

    def get_breed(self):
        """Get dogs breed."""
        return(self.breed)

# Create two Dog instances with name, age, and breed
maximus = Dog("Max", 6, "Yellow Lab")
bella = Dog("Bella", 2, "German Shepherd")

# Example of accessing instance attributes
print("{} {} {}.".format(maximus.name, maximus.age, maximus.breed))
print("{} {} {}.".format(bella.name, bella.age, bella.breed))

# Example of accessing a class attribute
if maximus.species == "mammal":
    print("{0} is a {1}!".format(maximus.name, maximus.species))

max_age = int(maximus.get_age())
bella_age = int(bella.get_age())
print(max_age)
print(bella_age)

print("Oldest is {}.".format(get_biggest_number(max_age, bella_age)))
