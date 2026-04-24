# Wasslti Restaurant Dashboard 🍽️

A modern, real-time restaurant dashboard for managing active orders using a Kanban board interface. Built with Next.js, Supabase, and dnd-kit.

---

## 🚀 Features

- 📦 Real-time order management (Supabase Realtime)
- 🧩 Kanban Board (Drag & Drop)
- 🔔 Notifications (Toast + Sound alerts)
- ⚡ Fast and responsive UI
- 🧠 Scalable architecture for future AI integrations

---

## 🏗️ Tech Stack

- Next.js (App Router)
- Supabase (Database + Realtime)
- dnd-kit (Drag & Drop)
- Tailwind CSS (UI Styling)

---

## 📁 Project Structure

```
/app
  /dashboard
    /orders
      page.tsx
      KanbanBoard.tsx
      OrderCard.tsx
      OrderColumn.tsx
/components
  Sidebar.tsx
  Header.tsx
/lib
  supabaseClient.ts
```

---

## ⚙️ Setup & Installation

### 1. Clone the repository

```bash
git clone https://github.com/your-username/wasslti-dashboard.git
cd wasslti-dashboard
```

### 2. Install dependencies

```bash
npm install
```

### 3. Setup environment variables

Create a `.env.local` file:

```
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_key
```

### 4. Run the development server

```bash
npm run dev
```

---

## 🗄️ Database Schema (Supabase)

### Orders Table

| Column        | Type      | Description |
|--------------|----------|------------|
| id           | uuid     | Primary key |
| user_id      | uuid     | Customer ID |
| restaurant_id| uuid     | Restaurant ID |
| status       | text     | Order status |
| total_price  | numeric  | Total price |
| created_at   | timestamp| Created time |
| updated_at   | timestamp| Updated time |

### Order Status Values

```
pending
accepted
preparing
ready
picked_up
on_the_way
delivered
cancelled
```

---

## 🔄 Realtime Updates

The dashboard listens to Supabase Realtime events and updates automatically when:
- New order is created
- Order status is updated

---

## 🔔 Notifications

- Toast notifications for new orders
- Sound alert on incoming orders

---

## 🎯 Roadmap

- 🤖 AI-based order prioritization
- 📊 Analytics dashboard
- 👨‍🍳 Kitchen mode UI
- 🚚 Driver integration

---

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

---

## 📄 License

MIT License

---

## 👨‍💻 Author

Built with passion by Wasslti Team 🚀
