from src.cieshw_pdf import templating
from pathlib import Path

path = Path("2023-07-12_15-51-50.85")

ret = templating.pdf(path)
print(f"templating returned: {ret}")

'''
\begin{figure}[H]
    \begin{center}
        \input{measured.pgf}
        \caption{Gemessene Werte und Regressionsfunktion einer Fahrt aus 1 m Entfernung zum Ziel.}
        \label{fig:mea}
    \end{center}
\end{figure}
'''