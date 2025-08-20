#include <stdio.h>
#include <string.h>

#include <stdio.h>
#include <string.h>

const char *
battery_perc_warn(const char *bat)
{
    int perc = -1;
    FILE *fp;
    char path[256];

    snprintf(path, sizeof(path), "/sys/class/power_supply/%s/capacity", bat);
    fp = fopen(path, "r");
    if (!fp)
        return NULL;

    fscanf(fp, "%d", &perc);
    fclose(fp);

    if (perc >= 0 && perc < 20) {
        static char buf[16];
        snprintf(buf, sizeof(buf), "%d%%", perc);
        return buf;
    }

    return "";  /* Show nothing if ≥20% */
}

