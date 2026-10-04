import sys
from pathlib import Path
from jinja2 import Environment, FileSystemLoader, StrictUndefined
from palette import load_palette

TEMPLATES_DIR = Path(__file__).resolve().parent.parent / "templates"

TARGETS = {
    "kitty":    ("kitty.conf.j2",   "~/.config/kitty/rice-shell.conf"),
    "hyprland": ("hyprland.lua.j2", "~/.config/hypr/modules/rice-shell.lua"),
}

env = Environment(
    loader=FileSystemLoader(TEMPLATES_DIR),
    trim_blocks=True,
    lstrip_blocks=True,
    keep_trailing_newline=True,
    undefined=StrictUndefined,
)


def render_target(palette: dict, target: str) -> str:
    template_name, _ = TARGETS[target]
    template = env.get_template(template_name)
    return template.render(
        name=palette["name"],
        colors=palette["colors"],
        ansi=palette["ansi"],
    )


def write_target(target: str, text: str) -> Path:
    _, out_path = TARGETS[target]
    out = Path(out_path).expanduser()
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(text)
    return out


def main():
    if len(sys.argv) < 2:
        print("uso: python render.py <paleta.json> [alvos...]")
        sys.exit(1)

    palette = load_palette(Path(sys.argv[1]))
    targets = sys.argv[2:] or list(TARGETS)

    for target in targets:
        if target not in TARGETS:
            print(f"alvo desconhecido: {target} (disponíveis: {', '.join(TARGETS)})")
            sys.exit(1)
        text = render_target(palette, target)
        out = write_target(target, text)
        print(f"{target} -> {out}")


if __name__ == "__main__":
    main()
