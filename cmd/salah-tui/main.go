package main

import (
	"fmt"
	"os"
	"time"

	tea "github.com/charmbracelet/bubbletea"
	gloss "github.com/charmbracelet/lipgloss"
)

const TAB_COUNT = 2

type model struct {
	count int
	tab   int
}

func initialModel() model { return model{tab: 0} }

func (m *model) switchTab() {
	m.tab = (m.tab + 1) % TAB_COUNT
}

func (m *model) showStatsView(style gloss.Style) string {
	return style.Render(fmt.Sprintf("Total prayers: %d", m.count))
}

func (m *model) showEntryView(style gloss.Style) string {
	today := time.Now().Format("2006-01-02")
	return style.Render(fmt.Sprintf("%s: Fajr, Dhuhr, Asr, Maghrib, Isha", today))
}

func (m model) Init() tea.Cmd {
	return nil
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.Type {
		case tea.KeyTab:
			m.switchTab()
		}
		switch msg.String() {
		case "q", "ctrl+c":
			return m, tea.Quit
		}
	}
	return m, nil
}

func (m model) View() string {
	style := gloss.NewStyle().
		Bold(true).
		Foreground(gloss.Color("#04B575"))

	views := []string{m.showStatsView(style), m.showEntryView(style)}

	return fmt.Sprintf("%s\n\nq to quit", views[m.tab])
}

func main() {
	p := tea.NewProgram(initialModel())
	if _, err := p.Run(); err != nil {
		fmt.Println("Error:", err)
		os.Exit(1)
	}
}
