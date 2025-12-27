godziny = ["12:00", "12:15", "12:30","12h00", "12h15", "12h30"]
godzina = random.choice(godziny)
title = ["iOS zaczynamy o {godzina}"]
message = ["Dzisiaj zacznniemy o {godzina}","Zaczynamy dzisiaj o {godzina}","Przypominam o tym, że zaczynamy o {godzina} dzisiaj.","Dzisiaj zaczniemy zajęcia o {godzina}."]

full_message = title + "Dzien dobry,\n\n" + message + "\n\nPozdrawiam,\nK."

godziny = ["12:00", "12:15", "12:30","12h00", "12h15", "12h30"]

def proste():
    godzina = random.choice(godziny)
    title = ["iOS zaczynamy o {godzina}"]
    message = ["Dzisiaj zacznniemy o {godzina}","Zaczynamy dzisiaj o {godzina}","Przypominam o tym, że zaczynamy o {godzina} dzisiaj.","Dzisiaj zaczniemy zajęcia o {godzina}."]

    full_message = title + "Dzien dobry,\n\n" + message + "\n\nPozdrawiam,\nK."
    return full_message
print(proste())
Ebiznes - zaczynamy 12:30

    Dzień dobry,

    Dzisiaj zaczniemy o 12:30.

    Pozdrawiam,
    K.

Ebiznes - 26.03 Zaczynamy o 12:00

    Dzień dobry,

    Zaczynamy dzisiaj o 12:00.

    Pozdrawiam,
    K.

Ebiznes - zaczynamy 12:30

    Dzień dobry,

    Przypominam o tym, że zaczynamy o 12:30 dzisiaj.

    Pozdrawiam,
    Karol Przystalski


Zaczynamy 12:15

    Dzień dobry,

    Dzisiaj zaczniemy o 12:15. Wynika z godzin dziekańskich od godz. 15.

    Pozdrawiam,
    K.

iOS - zaczynamy o 12:15

    Dzień dobry,

    Dzisiaj zaczniemy zajęcia o 12h15.

    Pozdrawiam,
    K.

iOS - zaczynamy na 12h30

    Dzień dobry,

    Zaczynamy dzisiaj o 12h30.

    Pozdrawiam,
    K.

import random # Należy zaimportować moduł 'random'

godziny = ["12:00", "12:15", "12:30", "12h00", "12h15", "12h30"]
def proste():
    godzina = random.choice(godziny)
    tytuly = [
        f"iOS - zaczynamy o {godzina}",
        f"iOS - zaczynamy na {godzina}",
        f"iOS - zaczynamy {godzina}",
        f"Zaczynamy {godzina}",
    ]
    tytul = random.choice(tytuly)
    tresci = [
        f"Dzisiaj zaczniemy o {godzina}.",
        f"Dzisiaj zaczniemy na {godzina}.",
        f"Dzisiaj zaczniemy {godzina}.",
        f"Zaczynamy dzisiaj o {godzina}.",
        f"Zaczynamy dzisiaj na {godzina}.",
        f"Zaczynamy dzisiaj {godzina}.",
        f"Przypominam, że zaczynamy o {godzina} dzisiaj.",
        f"Przypominam, że zaczynamy na {godzina} dzisiaj.",
        f"Przypominam, że zaczynamy {godzina} dzisiaj.",
        f"Przypominam o tym, że zaczynamy o {godzina} dzisiaj"
    ]
    tresc = random.choice(tresci)
    full_message = f"{tytul}\n\nDzień dobry,\n\n{tresc}\n\nPozdrawiam,\nK."
    return full_message
print(proste())

print("\n---\n")
print(proste())