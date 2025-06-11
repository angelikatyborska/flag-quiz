# Flag quiz

## Concept

### Identifying countries

ISO 3166-1 alpha-2

https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2

### Copyright

Flags are in the public domain.

### Flag patterns

- 2 stripes
- 3 stripes
- a few stars
- elaborate symbol somewhere in the middle

### Similar flags

### Flag tricks

- any flag = change hue/shade of one of the colors
- 2 stripes = swap colors
- 3 stripes = swap 1st with 3rd (e.g. France, Ireland)
- 3 stripes = swap any 2 colors (e.g. Bulgaria, Russia)
- 3 stripes = change ratio of stripe widths
- a few stars = change number of starts (e.g. China, Australia)
- with symbol = resize symbol, remove symbol (might cause duplication with other flags, e.g. remove symbol from Moldova and you get romania)
- most flags = previous version, e.g. Lesotho from the 70s
- flags with simple geometry like just stripes = change flag ratio
- flags with symbol in the middle = crop to change ratio instead of resizing?

### No cheating measures

- After transformation, each SVG needs to be turned to png?

### TO PNG options to avoid cheating

resvg rust nif works, but
doesn't support transform-box yet https://github.com/linebender/resvg/blob/main/docs/svg2-changelog.md#coordinate-systems-transformations-and-units

```elixir
  :ok = Resvg.svg_string_to_png(svg_string, "./output.png", resources_dir: "/tmp")
```

I will probably have to do with via a browser

## Generating questions

A question should consist of a 3x3 grid of fake flags.

Flags in one question should have a similar sets of transformations. E.g. if a flag has transformations "swap colors", "make square", and "remove star", then the question should include a version with "swap colors", "swap colors and make square", "swap colors and remove star", "make square", "remove star", "make square and remove star" and so on.

It should be hard to figure out what's the correct flag just by noticing the differences between fake answers.

If a flag has a transformation "make square", and it's similar to another flag that has a transformation "make square", then the question should include the another flag in original, and square versions of both flags.

## Common tweaks

- zoom_in_central_symbol
- zoom_out_central_symbol
- tricolor_swap_1_and_3
- rotate_stars (by 36 deg)
