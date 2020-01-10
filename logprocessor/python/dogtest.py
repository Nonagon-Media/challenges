"""Troubleshooting."""


class Dog:
    """Dog class."""

    # Class Attribute
    species = 'mammal'

    # Initializer / Instance Attributes
    def __init__(self, name, age):
        """Initialization."""
        self.name = name
        self.age = age


# Instantiate the Dog object
jake = Dog("Jake", 7)
doug = Dog("Doug", 4)
william = Dog("William", 5)


# Determine the oldest dog
def get_biggest_number(*args):
    """Public function."""
    return max(args)

print("Oldest {}".format(get_biggest_number(jake.age, doug.age, william.age)))
