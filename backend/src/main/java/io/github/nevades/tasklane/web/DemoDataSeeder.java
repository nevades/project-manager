package io.github.nevades.tasklane.web;

import io.github.nevades.tasklane.board.Board;
import io.github.nevades.tasklane.board.BoardList;
import io.github.nevades.tasklane.board.BoardListRepository;
import io.github.nevades.tasklane.board.BoardMember;
import io.github.nevades.tasklane.board.BoardMember.MemberRole;
import io.github.nevades.tasklane.board.BoardMemberRepository;
import io.github.nevades.tasklane.board.BoardRepository;
import io.github.nevades.tasklane.board.Label;
import io.github.nevades.tasklane.board.LabelRepository;
import io.github.nevades.tasklane.card.Card;
import io.github.nevades.tasklane.card.CardRepository;
import io.github.nevades.tasklane.card.ChecklistItem;
import io.github.nevades.tasklane.card.ChecklistItemRepository;
import io.github.nevades.tasklane.card.Comment;
import io.github.nevades.tasklane.card.CommentRepository;
import io.github.nevades.tasklane.card.Priority;
import io.github.nevades.tasklane.user.Role;
import io.github.nevades.tasklane.user.User;
import io.github.nevades.tasklane.user.UserRepository;
import java.time.LocalDate;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnBooleanProperty;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/**
 * Seeds a demo account and sample board on an empty database when {@code app.demo-data.enabled=true}.
 */
@Component
@ConditionalOnBooleanProperty("app.demo-data.enabled")
public class DemoDataSeeder implements ApplicationRunner {

    public static final String DEMO_EMAIL = "demo@example.com";
    public static final String DEMO_PASSWORD = "demo1234";

    private static final Logger log = LoggerFactory.getLogger(DemoDataSeeder.class);

    private final UserRepository users;
    private final BoardRepository boards;
    private final BoardMemberRepository members;
    private final BoardListRepository lists;
    private final LabelRepository labels;
    private final CardRepository cards;
    private final ChecklistItemRepository checklistItems;
    private final CommentRepository comments;
    private final PasswordEncoder passwordEncoder;

    public DemoDataSeeder(UserRepository users, BoardRepository boards, BoardMemberRepository members,
            BoardListRepository lists, LabelRepository labels, CardRepository cards,
            ChecklistItemRepository checklistItems, CommentRepository comments, PasswordEncoder passwordEncoder) {
        this.users = users;
        this.boards = boards;
        this.members = members;
        this.lists = lists;
        this.labels = labels;
        this.cards = cards;
        this.checklistItems = checklistItems;
        this.comments = comments;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional
    public void run(ApplicationArguments args) {
        if (users.count() > 0) {
            return;
        }
        User demo = users.save(new User(DEMO_EMAIL, "Demo User", passwordEncoder.encode(DEMO_PASSWORD), Role.ADMIN));
        User alex = users.save(new User("alex@example.com", "Alex Rivera", passwordEncoder.encode(DEMO_PASSWORD),
                Role.USER));
        User sam = users.save(new User("sam@example.com", "Sam Patel", passwordEncoder.encode(DEMO_PASSWORD),
                Role.USER));

        Board board = boards.save(new Board("Website Relaunch",
                "Plan, build and ship the new marketing site.", "ocean", demo));
        BoardMember owner = new BoardMember(board, demo, MemberRole.OWNER);
        owner.setStarred(true);
        members.saveAll(List.of(owner, new BoardMember(board, alex, MemberRole.MEMBER),
                new BoardMember(board, sam, MemberRole.MEMBER)));

        Label design = labels.save(new Label(board, "Design", "purple"));
        Label frontend = labels.save(new Label(board, "Frontend", "blue"));
        Label backend = labels.save(new Label(board, "Backend", "green"));
        Label bug = labels.save(new Label(board, "Bug", "red"));
        Label content = labels.save(new Label(board, "Content", "yellow"));

        BoardList backlog = lists.save(new BoardList(board, "Backlog", 0));
        BoardList todo = lists.save(new BoardList(board, "To do", 1));
        BoardList doing = lists.save(new BoardList(board, "In progress", 2));
        BoardList review = lists.save(new BoardList(board, "Review", 3));
        BoardList done = lists.save(new BoardList(board, "Done", 4));

        card(backlog, 0, demo, "Write blog post announcing the relaunch", Priority.LOW, null, null, content);
        card(backlog, 1, demo, "Evaluate analytics providers", Priority.NONE, null, null);

        Card hero = card(todo, 0, demo, "Design hero section", Priority.HIGH, alex, 5, design);
        hero.setDescription("Explore two directions for the hero: illustration-led and product-screenshot-led.");
        checklist(hero, "Moodboard", true);
        checklist(hero, "Low-fi wireframes", true);
        checklist(hero, "High-fi mockups", false);
        card(todo, 1, demo, "Set up contact form endpoint", Priority.MEDIUM, sam, 9, backend);

        Card nav = card(doing, 0, demo, "Build responsive navigation", Priority.MEDIUM, alex, 3, frontend);
        checklist(nav, "Desktop layout", true);
        checklist(nav, "Mobile drawer", false);
        comments.save(new Comment(nav, sam, "Remember to test keyboard navigation for the drawer."));
        card(doing, 1, demo, "Fix layout shift on pricing page", Priority.URGENT, sam, 1, bug, frontend);

        Card seo = card(review, 0, demo, "Add meta tags and sitemap", Priority.LOW, demo, null, frontend);
        comments.save(new Comment(seo, alex, "Looks good to me. Can we also add Open Graph images?"));

        Card kickoff = card(done, 0, demo, "Kick-off meeting", Priority.NONE, demo, -7);
        kickoff.setCompleted(true);
        Card brand = card(done, 1, demo, "Finalise brand colours", Priority.MEDIUM, alex, -3, design);
        brand.setCompleted(true);

        Board personal = boards.save(new Board("Personal", "Errands and ideas.", "sunset", demo));
        members.save(new BoardMember(personal, demo, MemberRole.OWNER));
        BoardList ideas = lists.save(new BoardList(personal, "Ideas", 0));
        lists.save(new BoardList(personal, "This week", 1));
        lists.save(new BoardList(personal, "Done", 2));
        card(ideas, 0, demo, "Learn a new keyboard shortcut every day", Priority.NONE, null, null);

        log.info("Seeded demo data. Sign in with {} / {}", DEMO_EMAIL, DEMO_PASSWORD);
    }

    private Card card(BoardList list, int position, User creator, String title, Priority priority, User assignee,
            Integer dueInDays, Label... cardLabels) {
        Card card = new Card(list, title, position, creator);
        card.setPriority(priority);
        card.setAssignee(assignee);
        if (dueInDays != null) {
            card.setDueDate(LocalDate.now().plusDays(dueInDays));
        }
        card.getLabels().addAll(List.of(cardLabels));
        return cards.save(card);
    }

    private void checklist(Card card, String content, boolean done) {
        ChecklistItem item = new ChecklistItem(card, content, checklistItems.countByCardId(card.getId()));
        item.setDone(done);
        checklistItems.save(item);
    }
}
