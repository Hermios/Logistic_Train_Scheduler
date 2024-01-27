data:extend(
{
  {
    type = "technology",
    name = tech,
    icon = "__"..modname.."__/graphics/technology/tech.png",
	  icon_size=128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = recipe
      },
    },
    prerequisites = {"advanced-electronics-2","automated-rail-transportation","circuit-network"},
    unit =
    {
      count = 400,
      ingredients =
      {
        {"automation-science-pack", 2.5},
        {"logistic-science-pack", 2},
        {"utility-science-pack", 1}
      },
      time = 20
    }
  }
})