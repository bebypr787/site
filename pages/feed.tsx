import PromoBanner from '@/components/PromoBanner';
import LiveBubbles from '@/components/LiveBubbles';
import SidebarHorizontalCards from '@/components/SidebarHorizontalCards';
import FeedFilters from '@/components/FeedFilters';
import PostList from '@/components/PostList';

export default function Feed() {
  return (
    <div className='grid lg:grid-cols-[1fr_340px] gap-6'>
      <div className='space-y-6'>
        <PromoBanner />
        <LiveBubbles />
        <FeedFilters />
        <PostList filter={{ tab: 'all', query: '', scope: 'public' }} />
      </div>
      <aside className='space-y-6'>
        <SidebarHorizontalCards />
      </aside>
    </div>
  );
}