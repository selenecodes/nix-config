_: {
  homeManager.work = {pkgs, ...}: let
    mattPocockSkills = builtins.fetchGit {
      url = "https://github.com/mattpocock/skills";
      rev = "ed37663cc5fbef691ddfecd080dff42f7e7e350d";
    };
    skills = pkgs.runCommand "matt-pocock-skills" {} ''
      mkdir -p "$out"
      while IFS= read -r -d "" skill; do
        name="$(basename "$(dirname "$skill")")"
        cp -R "$(dirname "$skill")" "$out/$name"
      done < <(find "${mattPocockSkills}/skills/engineering" "${mattPocockSkills}/skills/productivity" -mindepth 2 -maxdepth 2 -name SKILL.md -type f -print0)
    '';
  in {
    home.file.".agents/skills".source = skills;
  };
}
