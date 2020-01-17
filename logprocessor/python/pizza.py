"""More work with class methods."""


class Pizza:
    """Make a pizza."""

    def __init__(self, ingredients):
        """Initialize the object."""
        self.ingredients = ingredients

    def __repr__(self):
        """Retrieve the ingredients."""
        return('Pizza(%r)' % self.ingredients)

    @classmethod
    def margherita(cls):
        """A margherita."""
        return(cls(['mozzarella', 'tomatoes']))

    @classmethod
    def prosciutto(cls):
        """Prosciutto pizza."""
        return(cls(['mozzarella', 'tomatoes', 'ham']))

    @classmethod
    def pepperoni(cls):
        """Pepperoni pizza."""
        return(cls(['mozzarella', 'tomatoes', 'pepperoni']))


print(Pizza.margherita())
print(Pizza.prosciutto())
print(Pizza.pepperoni())
