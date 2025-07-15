from ranger.api.commands import Command
import re


class remove_brackets(Command):
    """
    :remove_brackets

    Remove [bracketed text] and fix spacing in filenames.
    """

    def execute(self):
        for fobj in self.fm.thisdir.files:
            old = fobj.basename

            # Remove bracketed text and extra spaces
            new = re.sub(r"\s*\[.?\]\s", " ", old)
            new = re.sub(r"\s+", " ", new).strip()

            # Remove space before last dot
            if "." in new:
                new = re.sub(r"\s+\.(?=[^.]*$)", ".", new)

            if new != old:
                self.fm.rename(fobj, new)
                self.fm.notify(f"Renamed: {old} → {new}")
