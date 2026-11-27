package io.github.nevades.tasklane.card;

import io.github.nevades.tasklane.board.Positioned;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "checklist_items")
public class ChecklistItem implements Positioned {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "card_id")
    private Card card;

    @Column(nullable = false)
    private String content;

    @Column(nullable = false)
    private boolean done;

    @Column(nullable = false)
    private int position;

    protected ChecklistItem() {
    }

    public ChecklistItem(Card card, String content, int position) {
        this.card = card;
        this.content = content;
        this.position = position;
    }

    public Long getId() {
        return id;
    }

    public Card getCard() {
        return card;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean isDone() {
        return done;
    }

    public void setDone(boolean done) {
        this.done = done;
    }

    @Override
    public int getPosition() {
        return position;
    }

    @Override
    public void setPosition(int position) {
        this.position = position;
    }
}
