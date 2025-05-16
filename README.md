# Flag quiz

## Concept

### Identifying countries

ISO 3166-1 alpha-2

https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2

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
